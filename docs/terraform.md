## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.35 |
| <a name="requirement_mssql"></a> [mssql](#requirement\_mssql) | ~> 0.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.35 |
| <a name="provider_mssql"></a> [mssql](#provider\_mssql) | ~> 0.6 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.owner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.owner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.owner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.owner_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.user_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [mssql_database.this](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/resources/database) | resource |
| [mssql_database_role_member.dbowner](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/resources/database_role_member) | resource |
| [mssql_database_role_member.user_all_db](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/resources/database_role_member) | resource |
| [mssql_schema_permission.user_ro_tab_def_priv](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/resources/schema_permission) | resource |
| [mssql_schema_permission.user_tab_def_priv](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/resources/schema_permission) | resource |
| [mssql_sql_login.owner](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/resources/sql_login) | resource |
| [mssql_sql_login.user](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/resources/sql_login) | resource |
| [mssql_sql_user.owner](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/resources/sql_user) | resource |
| [mssql_sql_user.user](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/resources/sql_user) | resource |
| [random_password.owner](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.owner_initial](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.user_initial](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_rotating.owner](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [time_rotating.user](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [aws_db_instance.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_instance) | data source |
| [aws_db_instance.hoop_db_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_instance) | data source |
| [aws_lambda_function.rotation_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_function) | data source |
| [aws_rds_cluster.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_cluster) | data source |
| [aws_rds_cluster.hoop_db_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_cluster) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.db_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.db_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.owner_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.user_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_versions.owner_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_versions) | data source |
| [aws_secretsmanager_secret_versions.user_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_versions) | data source |
| [aws_secretsmanager_secrets.owner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secrets) | data source |
| [aws_secretsmanager_secrets.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secrets) | data source |
| [mssql_database.this](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/data-sources/database) | data source |
| [mssql_database_role.db_owner](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/data-sources/database_role) | data source |
| [mssql_schemas.all_schemas](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/data-sources/schemas) | data source |
| [mssql_server_role.public](https://registry.terraform.io/providers/PGSSoft/mssql/latest/docs/data-sources/server_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_databases"></a> [databases](#input\_databases) | databases:<br/>  <db\_ref>:<br/>    name: "db\_name"                        # (Required) Name of the database<br/>    create: true                           # (Optional) Whether to create the database. Defaults to true<br/>    create\_owner: false                    # (Optional) If the database should be created with an owner. Defaults to false<br/>    owner: "owner\_name"                    # (Optional) Owner of the database, required if create\_owner is false<br/>    default\_collation: "SQL\_Latin1\_General\_CP1\_CI\_AS" # (Optional) Collation of the database. Defaults to server default<br/>    default\_language: "English"            # (Optional) Default language for the owner user<br/>    check\_password\_expiration: false       # (Optional) Check password expiration for owner. Defaults to false<br/>    check\_password\_policy: false           # (Optional) Check password policy for owner. Defaults to false<br/>    must\_change\_password: false            # (Optional) Must change password for owner on first login. Defaults to false | `any` | `{}` | no |
| <a name="input_direct"></a> [direct](#input\_direct) | direct:<br/>  server\_name: "server"                    # (Required) Logical server name<br/>  host: "host\_address"                     # (Required) Database host address<br/>  port: 1433                               # (Required) Database port<br/>  jump\_host: "jump\_host"                   # (Optional) Jump host address<br/>  jump\_port: 22                            # (Optional) Jump host port<br/>  username: "admin"                        # (Optional) Database username<br/>  password: "password"                     # (Optional) Database password<br/>  secret\_name: "secret\_path"               # (Optional) AWS Secrets Manager secret name for credentials<br/>  engine: "sqlserver"                     # (Optional) Database engine. Defaults to sqlserver<br/>  db\_name: "master"                        # (Optional) Default database name | `any` | `{}` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_force_reset"></a> [force\_reset](#input\_force\_reset) | Force Reset the password # (Optional) Defaults to false | `bool` | `false` | no |
| <a name="input_hoop"></a> [hoop](#input\_hoop) | Hoop connection output settings for terraform-module-hoop-connection - see docs for example | `any` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_password_rotation_period"></a> [password\_rotation\_period](#input\_password\_rotation\_period) | Password rotation period in days # (Optional) Defaults to 90 | `number` | `90` | no |
| <a name="input_rds"></a> [rds](#input\_rds) | rds:<br/>  enabled: false                           # (Optional) If the RDS should be enabled. Defaults to false<br/>  name: "rds\_instance\_id"                  # (Optional) Name of the RDS instance or cluster. Required if enabled is true<br/>  secret\_name: "secret\_path"               # (Optional) Name of the AWS Secrets Manager secret. Required if enabled is true<br/>  cluster: false                           # (Optional) If the RDS is an Aurora RDS Cluster. Defaults to false<br/>  from\_secret: false                       # (Optional) Read all connection details from secret. Defaults to false<br/>  server\_name: "logical\_name"              # (Optional) Override server logical name | `any` | `{}` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | roles:<br/>  <role\_ref>:<br/>    name: "role\_name"                      # (Required) Name of the role<br/>    db\_ref: "db\_reference"                 # (Optional) Reference to the database this role is associated with. Defaults to the default dbname of server<br/>    database\_name: "db\_name"               # (Optional) Name of the database this role is associated with. Defaults to the default dbname of server<br/>    table\_name: "table\_name"               # (Optional) Name of the table this role is associated with. Defaults to `*`<br/>    grant\_option: false                    # (Optional) If the role has grant option. Defaults to false<br/>    grants:                                # (Optional) Grants for the role. Defaults to ALL PRIVILEGES<br/>      - "SELECT" | `any` | `{}` | no |
| <a name="input_rotate_immediately"></a> [rotate\_immediately](#input\_rotate\_immediately) | Rotate the password immediately # (Optional) Defaults to false | `bool` | `false` | no |
| <a name="input_rotation_duration"></a> [rotation\_duration](#input\_rotation\_duration) | Duration of the lambda function to rotate the password # (Optional) Defaults to 1h | `string` | `"1h"` | no |
| <a name="input_rotation_lambda_name"></a> [rotation\_lambda\_name](#input\_rotation\_lambda\_name) | Name of the lambda function to rotate the password # (Optional) Defaults to empty | `string` | `""` | no |
| <a name="input_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#input\_secrets\_kms\_key\_id) | (optional) KMS Key ID to use to encrypt data in this secret, can be ARN or KMS Alias # (Optional) Defaults to null | `string` | `null` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_users"></a> [users](#input\_users) | users:<br/>  <user\_ref>:<br/>    name: "user\_name"                      # (Required) Name of the user<br/>    grant: "owner"                         # (Required) Grant type for the user. Possible values: owner, readwrite, readonly<br/>    db\_ref: "db\_reference"                 # (Optional) Reference to the database this user is associated with. Defaults to the default dbname of server<br/>    database\_id: "db\_id"                   # (Optional) Direct ID of the database this user is associated with<br/>    default\_language: "English"            # (Optional) Default language for the user<br/>    check\_password\_expiration: false       # (Optional) Check password expiration. Defaults to false<br/>    check\_password\_policy: false           # (Optional) Check password policy. Defaults to false<br/>    must\_change\_password: false            # (Optional) Must change password on first login. Defaults to false | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hoop_connections"></a> [hoop\_connections](#output\_hoop\_connections) | n/a |
| <a name="output_owners"></a> [owners](#output\_owners) | n/a |
| <a name="output_users"></a> [users](#output\_users) | n/a |
