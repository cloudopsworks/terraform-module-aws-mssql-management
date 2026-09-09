##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# Users granted "owner" join db_owner in every database they are assigned to.
resource "mssql_database_role_member" "user_all_db" {
  for_each = {
    for pair_key, target in local.user_all_targets : pair_key => target
    if try(var.users[target.user_key].grant, "") == "owner" && target.resolvable
  }
  role_id   = local.db_owner_role_ids[each.value.target_key]
  member_id = local.user_principal_ids[each.key]
}
