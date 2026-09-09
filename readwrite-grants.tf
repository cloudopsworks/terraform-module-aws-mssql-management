##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "mssql_schema_permission" "user_tab_def_priv" {
  for_each = {
    for key, grant in local.user_schema_grants : key => grant if grant.grant == "readwrite"
  }
  schema_id    = local.schema_mapping[each.value.target_key][each.value.schema]
  principal_id = local.user_principal_ids[each.value.pair_key]
  permission   = "SELECT, INSERT, UPDATE, DELETE, EXECUTE"
}
