##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#
data "mssql_schema" "user_rw_schema" {
  for_each = {
    for key, user in var.users : key => user if try(user.grant, "") == "readwrite"
  }
  name        = try(each.value.schema, "dbo")
  database_id = try(each.value.db_ref, "") != "" ? mssql_database.this[each.value.db_ref].id : each.value.database_id
}

resource "mssql_schema_permission" "user_tab_def_priv" {
  for_each = {
    for key, user in var.users : key => user if try(user.grant, "") == "readwrite"
  }
  schema_id    = data.mssql_schema.user_rw_schema[each.key].id
  principal_id = mssql_sql_login.user[each.key].id
  permission   = "SELECT, INSERT, UPDATE, DELETE, EXECUTE"
}
