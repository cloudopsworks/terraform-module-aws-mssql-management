##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "time_rotating" "owner" {
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false) && var.rotation_lambda_name == ""
  }
  rotation_days = var.password_rotation_period
}

resource "random_password" "owner" {
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false) && var.rotation_lambda_name == ""
  }
  length           = 25
  special          = var.specials_in_password
  override_special = "=_-+@~#"
  min_upper        = 2
  min_special      = var.specials_in_password ? 2 : 0
  min_numeric      = 2
  min_lower        = 2
  lifecycle {
    replace_triggered_by = [
      time_rotating.owner[each.key].rotation_rfc3339
    ]
  }
}

resource "random_password" "owner_initial" {
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false) && var.rotation_lambda_name != ""
  }
  length           = 25
  special          = var.specials_in_password
  override_special = "=_-+~#"
  min_upper        = 2
  min_special      = var.specials_in_password ? 2 : 0
  min_numeric      = 2
  min_lower        = 2
}

data "mssql_database" "this" {
  for_each = {
    for key, db in var.databases : key => db if !try(db.create, true)
  }
  name = each.value.name
}

resource "mssql_database" "this" {
  for_each = {
    for key, db in var.databases : key => db if try(db.create, true)
  }
  name      = each.value.name
  collation = try(each.value.default_collation, null)
}

#############################################################################
## SCHEMAS
#############################################################################

data "mssql_schemas" "all_schemas" {
  for_each    = var.databases
  database_id = local.database_ids[each.key]
}

# Schemas of databases referenced by users through a verbatim `database_id`
# instead of a `db_ref`, so schema grants resolve for them too.
data "mssql_schemas" "external" {
  for_each    = toset(local.external_database_ids)
  database_id = each.value
}

resource "mssql_schema" "this" {
  for_each    = local.database_schemas
  name        = each.value.name
  database_id = local.database_ids[each.value.db_key]
  owner_id = each.value.owner_ref != null ? (
    local.user_principal_ids[format("%s/%s", each.value.owner_ref, each.value.db_key)]
  ) : null
}

#############################################################################
## OWNERS
#############################################################################

resource "mssql_sql_login" "owner" {
  depends_on = [mssql_database.this]
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false)
  }
  name = local.owner_list[each.key]
  password = var.rotation_lambda_name == "" ? random_password.owner[each.key].result : (
    try(length(data.aws_secretsmanager_secret_versions.owner_rotated[each.key].versions), 0) > 0 && !var.force_reset ?
    jsondecode(data.aws_secretsmanager_secret_version.owner_rotated[each.key].secret_string)["password"] :
    random_password.owner_initial[each.key].result
  )
  default_database_id       = local.database_ids[each.key]
  default_language          = try(each.value.default_language, null)
  check_password_expiration = try(each.value.check_password_expiration, false)
  check_password_policy     = try(each.value.check_password_policy, false)
  must_change_password      = try(each.value.must_change_password, false)
}

resource "mssql_sql_user" "owner" {
  depends_on = [mssql_sql_login.owner]
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false)
  }
  name        = local.owner_list[each.key]
  login_id    = mssql_sql_login.owner[each.key].id
  database_id = local.database_ids[each.key]
}

# A global owner is materialised as a database user in every other declared
# database as well, so a single credential can administer all of them.
resource "mssql_sql_user" "owner_global" {
  depends_on  = [mssql_sql_login.owner]
  for_each    = local.global_owner_targets
  name        = local.owner_list[each.value.owner_key]
  login_id    = mssql_sql_login.owner[each.value.owner_key].id
  database_id = local.database_ids[each.value.db_key]
}

data "mssql_server_role" "public" {
  name = "public"
}

data "mssql_database_role" "db_owner" {
  for_each    = var.databases
  database_id = local.database_ids[each.key]
  name        = "db_owner"
}

data "mssql_database_role" "db_owner_external" {
  for_each    = toset(local.external_database_ids)
  database_id = each.value
  name        = "db_owner"
}

# resource "mssql_server_role_member" "owner_public" {
#   depends_on = [mssql_sql_login.owner]
#   for_each = {
#     for key, db in var.databases : key => db if try(db.create_owner, false)
#   }
#   role_id   = data.mssql_server_role.public.id
#   member_id = mssql_sql_login.owner[each.key].principal_id
# }

resource "mssql_database_role_member" "dbowner" {
  depends_on = [mssql_sql_login.owner]
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false)
  }
  role_id   = data.mssql_database_role.db_owner[each.key].id
  member_id = mssql_sql_user.owner[each.key].id
}

resource "mssql_database_role_member" "dbowner_global" {
  depends_on = [mssql_sql_login.owner]
  for_each   = local.global_owner_targets
  role_id    = data.mssql_database_role.db_owner[each.value.db_key].id
  member_id  = mssql_sql_user.owner_global[each.key].id
}
