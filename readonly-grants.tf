##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "mssql_schema_permission" "user_ro_tab_def_priv" {
  for_each = {
    for key, user in var.users : key => user if try(user.grant, "") == "readonly"
  }
  schema_id    = local.schema_maping[try(each.value.db_ref, "") != "" ? each.value.db_ref : each.value.database_id][try(each.value.schema, "dbo")]
  principal_id = mssql_sql_user.user[each.key].id
  permission   = "SELECT"
}