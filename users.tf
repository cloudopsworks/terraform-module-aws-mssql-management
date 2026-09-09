##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "time_rotating" "user" {
  for_each = {
    for k, user in var.users : k => user if var.rotation_lambda_name == ""
  }
  rotation_days = var.password_rotation_period
}

resource "random_password" "user" {
  for_each = {
    for k, user in var.users : k => user if var.rotation_lambda_name == ""
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
      time_rotating.user[each.key].rotation_rfc3339
    ]
  }
}

resource "random_password" "user_initial" {
  for_each = {
    for k, user in var.users : k => user if var.rotation_lambda_name != ""
  }
  length           = 25
  special          = var.specials_in_password
  override_special = "=_-+@~#"
  min_upper        = 2
  min_special      = var.specials_in_password ? 2 : 0
  min_numeric      = 2
  min_lower        = 2
}

# One server-level login per user, regardless of how many databases the user is
# assigned to. Its default database is the first of those databases.
resource "mssql_sql_login" "user" {
  for_each = var.users
  name     = each.value.name
  password = var.rotation_lambda_name == "" ? random_password.user[each.key].result : (
    try(length(data.aws_secretsmanager_secret_versions.user_rotated[each.key].versions), 0) > 0 && !var.force_reset ?
    jsondecode(data.aws_secretsmanager_secret_version.user_rotated[each.key].secret_string)["password"] :
    random_password.user_initial[each.key].result
  )
  default_database_id       = local.user_default_target[each.key].database_id
  default_language          = try(each.value.default_language, null)
  check_password_expiration = try(each.value.check_password_expiration, false)
  check_password_policy     = try(each.value.check_password_policy, false)
  must_change_password      = try(each.value.must_change_password, false)
}

# Database user in the user's default (first) database. Keyed by user reference
# so the resource address is unchanged for single-database users.
resource "mssql_sql_user" "user" {
  for_each    = var.users
  name        = each.value.name
  database_id = local.user_default_target[each.key].database_id
  login_id    = mssql_sql_login.user[each.key].id
}

# Database user in every additional database the user is assigned to, keyed by
# "<user_ref>/<db_ref or database_id>".
resource "mssql_sql_user" "user_extra" {
  for_each    = local.user_extra_targets
  name        = var.users[each.value.user_key].name
  database_id = each.value.database_id
  login_id    = mssql_sql_login.user[each.value.user_key].id
}

# resource "mssql_server_role_member" "user_public" {
#   for_each  = var.users
#   role_id   = data.mssql_server_role.public.id
#   member_id = mssql_sql_login.user[each.key].principal_id
# }
