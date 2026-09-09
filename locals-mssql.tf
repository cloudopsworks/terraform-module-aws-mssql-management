##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  #############################################################################
  ## DATABASE IDENTITY
  ## Single resolution point for created vs. pre-existing databases, so the
  ## rest of the module never repeats the create/data-source ternary.
  #############################################################################
  database_ids = {
    for key, db in var.databases : key => (
      try(db.create, true) ? mssql_database.this[key].id : data.mssql_database.this[key].id
    )
  }
  # Taken from the declaration rather than from the resource: the value is
  # identical either way, and keeping it known at plan time is what lets the
  # Secrets Manager `import` blocks resolve their ids.
  database_names = {
    for key, db in var.databases : key => db.name
  }

  #############################################################################
  ## SCHEMAS
  ## `dbo` is created by SQL Server with every database and is the default
  ## schema for principals, so it is never managed as a resource. The same
  ## applies to the other built-in schemas. Declaring any of them is accepted
  ## and simply resolves to the existing schema.
  #############################################################################
  reserved_schemas = ["dbo", "guest", "sys", "information_schema"]
  default_schema   = "dbo"

  # Flattened declaration of every schema this module creates, keyed by
  # "<db_ref>/<schema_name>". Entries may be given as a bare string or as an
  # object carrying an owner reference.
  database_schemas = {
    for item in flatten([
      for db_key, db in var.databases : [
        for schema in try(db.schemas, []) : {
          key       = format("%s/%s", db_key, try(schema.name, schema))
          db_key    = db_key
          name      = try(schema.name, schema)
          owner_ref = try(schema.owner_ref, null)
        }
        if !contains(local.reserved_schemas, lower(try(schema.name, schema)))
      ]
    ]) : item.key => item
  }

  #############################################################################
  ## USER -> DATABASE ASSIGNMENT
  ## A user owns exactly one server-level login and one database user per
  ## database it is assigned to. The first entry of the resolved list is the
  ## default: it drives the login's default database, the Secrets Manager
  ## secret name and the credentials stored in it.
  ##
  ## Precedence, highest first: database_id, db_ref, database_ids[], db_refs[].
  ## The two singular attributes keep the precedence they had before multiple
  ## databases were supported.
  #############################################################################
  user_db_ids = {
    for key, user in var.users : key => distinct(compact(concat(
      [try(user.database_id, "")],
      try(user.database_ids, [])
    )))
  }
  user_db_refs = {
    for key, user in var.users : key => distinct(compact(concat(
      [try(user.db_ref, "")],
      try(user.db_refs, [])
    )))
  }

  # Database ids referenced verbatim rather than through `databases`. These
  # need their own schema and role lookups because the module does not manage
  # the database itself.
  external_database_ids = distinct(flatten([
    for key, ids in local.user_db_ids : ids
  ]))

  user_targets_declared = {
    for key, user in var.users : key => concat(
      [
        for id in local.user_db_ids[key] : {
          target_key    = id
          database_id   = id
          database_name = try(user.database_name, id)
          resolvable    = true
        }
      ],
      [
        for ref in local.user_db_refs[key] : {
          target_key    = ref
          database_id   = local.database_ids[ref]
          database_name = local.database_names[ref]
          resolvable    = true
        }
      ]
    )
  }

  # A user with no database assignment at all falls back to the server default
  # database (`master` for the mssql provider). Such a user gets a login and a
  # database user, but no schema or role grants can be resolved for it.
  user_targets = {
    for key, user in var.users : key => (
      length(local.user_targets_declared[key]) > 0 ? local.user_targets_declared[key] : [
        {
          target_key    = "__default__"
          database_id   = null
          database_name = try(user.database_name, try(local.psql.db_name, "master"))
          resolvable    = false
        }
      ]
    )
  }
  user_default_target = {
    for key, targets in local.user_targets : key => targets[0]
  }

  # Every (user, database) pair beyond the default one, keyed by
  # "<user_ref>/<target_key>".
  user_extra_targets = {
    for item in flatten([
      for key, targets in local.user_targets : [
        for target in slice(targets, 1, length(targets)) : merge(target, {
          key      = format("%s/%s", key, target.target_key)
          user_key = key
        })
      ]
    ]) : item.key => item
  }

  # Every (user, database) pair including the default one. Grants iterate this.
  user_all_targets = merge(
    {
      for key, targets in local.user_targets :
      format("%s/%s", key, targets[0].target_key) => merge(targets[0], {
        key      = format("%s/%s", key, targets[0].target_key)
        user_key = key
      })
    },
    local.user_extra_targets
  )

  # Database-user principal id per pair. The default pair is served by
  # `mssql_sql_user.user`, which keeps the resource address it had before
  # multiple databases were supported.
  user_principal_ids = merge(
    {
      for key, targets in local.user_targets :
      format("%s/%s", key, targets[0].target_key) => mssql_sql_user.user[key].id
    },
    {
      for pair_key, target in local.user_extra_targets :
      pair_key => mssql_sql_user.user_extra[pair_key].id
    }
  )

  #############################################################################
  ## SCHEMA MAPPING
  ## Schema name -> schema id, per database target. Schemas created by this
  ## module are merged last so a freshly declared schema resolves within the
  ## same apply instead of only after the next refresh.
  #############################################################################
  schema_mapping = merge(
    {
      for db_key, db in var.databases : db_key => merge(
        {
          for schema in data.mssql_schemas.all_schemas[db_key].schemas : schema.name => schema.id
        },
        {
          for schema_key, schema in local.database_schemas :
          schema.name => mssql_schema.this[schema_key].id if schema.db_key == db_key
        }
      )
    },
    {
      for id in local.external_database_ids : id => {
        for schema in data.mssql_schemas.external[id].schemas : schema.name => schema.id
      }
    }
  )

  # db_owner role id per database target, for both managed and verbatim ids.
  db_owner_role_ids = merge(
    {
      for db_key, db in var.databases : db_key => data.mssql_database_role.db_owner[db_key].id
    },
    {
      for id in local.external_database_ids : id => data.mssql_database_role.db_owner_external[id].id
    }
  )

  #############################################################################
  ## SCHEMA GRANTS
  ## Schemas a user is granted on, applied to every database it is assigned to.
  ## `schema` (singular) and `schemas` (list) may both be used; when neither is
  ## given the user is granted on `dbo`.
  #############################################################################
  user_schemas = {
    for key, user in var.users : key => (
      length(distinct(concat(compact([try(user.schema, "")]), try(user.schemas, [])))) > 0 ?
      distinct(concat(compact([try(user.schema, "")]), try(user.schemas, []))) :
      [local.default_schema]
    )
  }

  # One entry per (user, database, schema), keyed by
  # "<user_ref>/<target_key>/<schema_name>".
  user_schema_grants = {
    for item in flatten([
      for pair_key, target in local.user_all_targets : [
        for schema in local.user_schemas[target.user_key] : {
          key        = format("%s/%s", pair_key, schema)
          pair_key   = pair_key
          user_key   = target.user_key
          target_key = target.target_key
          schema     = schema
          grant      = try(var.users[target.user_key].grant, "")
        }
      ]
      if target.resolvable
    ]) : item.key => item
  }

  #############################################################################
  ## OWNERS
  #############################################################################
  owner_list = {
    for key, db in var.databases : key => "${db.name}_ow" if try(db.create_owner, false)
  }

  # Owners declared as global: they become db_owner of every declared database,
  # not only of the database that defines them.
  global_owner_db_keys = [
    for key, db in var.databases : key
    if try(db.global_owner, false) && try(db.create_owner, false)
  ]

  # One entry per (global owner, other database), keyed by
  # "<owner_db_ref>/<db_ref>". The owner's own database is excluded because it
  # is already covered by the per-database owner resources.
  global_owner_targets = {
    for item in flatten([
      for owner_key in local.global_owner_db_keys : [
        for db_key, db in var.databases : {
          key       = format("%s/%s", owner_key, db_key)
          owner_key = owner_key
          db_key    = db_key
        }
        if db_key != owner_key
      ]
    ]) : item.key => item
  }
}
