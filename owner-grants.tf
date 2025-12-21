##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# TODO: Fix resolution of role under existing DBs
resource "mssql_database_role_member" "user_all_db" {
  for_each = {
    for key, user in var.users : key => user if try(user.grant, "") == "owner"
  }
  role_id   = try(each.value.db_ref, "") != "" ? data.mssql_database_role.db_owner[each.value.db_ref].id : null
  member_id = mssql_sql_login.user[each.key].id
}