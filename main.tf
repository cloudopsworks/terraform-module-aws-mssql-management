##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  owner_list = {
    for key, db in var.databases : key => "${db.name}_ow" if try(db.create_owner, false)
  }
}

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
  special          = true
  override_special = "=_-+@~#"
  min_upper        = 2
  min_special      = 2
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
  special          = true
  override_special = "=_-+~#"
  min_upper        = 2
  min_special      = 2
  min_numeric      = 2
  min_lower        = 2
}

resource "mssql_database" "this" {
  for_each  = var.databases
  name      = each.value.name
  collation = try(each.value.default_collation, null)
}

data "mssql_schemas" "all_schemas" {
  for_each = {
    for key, db in var.databases : key => db
  }
  database_id = mssql_database.this[each.key].id
}

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
  default_database_id       = mssql_database.this[each.key].id
  default_language          = try(each.value.default_language, null)
  check_password_expiration = try(each.value.check_password_expiration, true)
  check_password_policy     = try(each.value.check_password_policy, true)
  must_change_password      = try(each.value.must_change_password, true)
}

resource "mssql_sql_user" "owner" {
  depends_on = [mssql_sql_login.owner]
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false)
  }
  name        = local.owner_list[each.key]
  login_id    = mssql_sql_login.owner[each.key].id
  database_id = mssql_database.this[each.key].id
}

data "mssql_server_role" "public" {
  name = "public"
}

data "mssql_database_role" "db_owner" {
  for_each = {
    for key, db in var.databases : key => db
  }
  database_id = mssql_database.this[each.key].id
  name        = "db_owner"
}

resource "mssql_server_role_member" "owner_public" {
  depends_on = [mssql_sql_login.owner]
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false)
  }
  role_id   = data.mssql_server_role.public.id
  member_id = mssql_sql_user.owner[each.key].id
}

resource "mssql_database_role_member" "dbowner" {
  depends_on = [mssql_sql_login.owner]
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false)
  }
  role_id   = data.mssql_database_role.db_owner[each.key].id
  member_id = mssql_sql_user.owner[each.key].id
}