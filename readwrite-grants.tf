##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  schema_maping = {
    for key, db in var.databases : key => {
      for schema in data.mssql_schemas.all_schemas[key].schemas : schema.name => schema.id
    }
  }
}


resource "mssql_schema_permission" "user_tab_def_priv" {
  for_each = {
    for key, user in var.users : key => user if try(user.grant, "") == "readwrite"
  }
  schema_id    = local.schema_maping[try(each.value.db_ref, "") != "" ? each.value.db_ref : each.value.database_id][try(each.value.schema, "dbo")]
  principal_id = mssql_sql_user.user[each.key].id
  permission   = "SELECT, INSERT, UPDATE, DELETE, EXECUTE"
}
