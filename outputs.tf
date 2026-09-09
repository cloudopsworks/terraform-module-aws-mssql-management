##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#


output "owners" {
  description = "Managed database owners and their Secrets Manager credential references."
  value = {
    for key, db in var.databases : key => {
      username               = local.owner_list[key]
      credentials_secret     = aws_secretsmanager_secret.owner[key].name
      credentials_secret_arn = aws_secretsmanager_secret.owner[key].arn
      global                 = try(db.global_owner, false)
    }
    if try(db.create_owner, false)
  }
}

output "users" {
  description = "Managed database users, the databases they are assigned to, and their Secrets Manager credential references."
  value = {
    for key, user in var.users : key => {
      username               = user.name
      credentials_secret     = aws_secretsmanager_secret.user[key].name
      credentials_secret_arn = aws_secretsmanager_secret.user[key].arn
      default_database       = local.user_default_target[key].database_name
      databases              = [for target in local.user_targets[key] : target.database_name]
    }
  }
}

output "databases" {
  description = "Managed databases keyed by their reference, with the resolved server-side database id."
  value = {
    for key, db in var.databases : key => {
      name = local.database_names[key]
      id   = local.database_ids[key]
    }
  }
}

output "schemas" {
  description = "Schemas created by this module, keyed by \"<db_ref>/<schema_name>\"."
  value = {
    for key, schema in local.database_schemas : key => {
      name        = schema.name
      database    = local.database_names[schema.db_key]
      database_id = local.database_ids[schema.db_key]
      schema_id   = mssql_schema.this[key].id
    }
  }
}
