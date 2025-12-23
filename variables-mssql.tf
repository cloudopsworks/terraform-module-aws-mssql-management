##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## Users definition - YAML format
# users:
#   <user_ref>:
#     name: "user_name"                      # (Required) Name of the user
#     grant: "owner"                         # (Required) Grant type for the user. Possible values: owner, readwrite, readonly
#     db_ref: "db_reference"                 # (Optional) Reference to the database this user is associated with. Defaults to the default dbname of server
#     database_id: "db_id"                   # (Optional) Direct ID of the database this user is associated with
#     default_language: "English"            # (Optional) Default language for the user
#     check_password_expiration: false       # (Optional) Check password expiration. Defaults to false
#     check_password_policy: false           # (Optional) Check password policy. Defaults to false
#     must_change_password: false            # (Optional) Must change password on first login. Defaults to false
variable "users" {
  description = <<-EOT
users:
  <user_ref>:
    name: "user_name"                      # (Required) Name of the user
    grant: "owner"                         # (Required) Grant type for the user. Possible values: owner, readwrite, readonly
    db_ref: "db_reference"                 # (Optional) Reference to the database this user is associated with. Defaults to the default dbname of server
    database_id: "db_id"                   # (Optional) Direct ID of the database this user is associated with
    default_language: "English"            # (Optional) Default language for the user
    check_password_expiration: false       # (Optional) Check password expiration. Defaults to false
    check_password_policy: false           # (Optional) Check password policy. Defaults to false
    must_change_password: false            # (Optional) Must change password on first login. Defaults to false
EOT
  type        = any
  default     = {}
}

## Roles definition - YAML format
# roles:
#   <role_ref>:
#     name: "role_name"                      # (Required) Name of the role
#     db_ref: "db_reference"                 # (Optional) Reference to the database this role is associated with. Defaults to the default dbname of server
#     database_name: "db_name"               # (Optional) Name of the database this role is associated with. Defaults to the default dbname of server
#     table_name: "table_name"               # (Optional) Name of the table this role is associated with. Defaults to `*`
#     grant_option: false                    # (Optional) If the role has grant option. Defaults to false
#     grants:                                # (Optional) Grants for the role. Defaults to ALL PRIVILEGES
#       - "SELECT"
variable "roles" {
  description = <<-EOT
roles:
  <role_ref>:
    name: "role_name"                      # (Required) Name of the role
    db_ref: "db_reference"                 # (Optional) Reference to the database this role is associated with. Defaults to the default dbname of server
    database_name: "db_name"               # (Optional) Name of the database this role is associated with. Defaults to the default dbname of server
    table_name: "table_name"               # (Optional) Name of the table this role is associated with. Defaults to `*`
    grant_option: false                    # (Optional) If the role has grant option. Defaults to false
    grants:                                # (Optional) Grants for the role. Defaults to ALL PRIVILEGES
      - "SELECT"
EOT
  type        = any
  default     = {}
}

## Databases definition - YAML format
# databases:
#   <db_ref>:
#     name: "db_name"                        # (Required) Name of the database
#     create: true                           # (Optional) Whether to create the database. Defaults to true
#     create_owner: false                    # (Optional) If the database should be created with an owner. Defaults to false
#     owner: "owner_name"                    # (Optional) Owner of the database, required if create_owner is false
#     default_collation: "SQL_Latin1_General_CP1_CI_AS" # (Optional) Collation of the database. Defaults to server default
#     default_language: "English"            # (Optional) Default language for the owner user
#     check_password_expiration: false       # (Optional) Check password expiration for owner. Defaults to false
#     check_password_policy: false           # (Optional) Check password policy for owner. Defaults to false
#     must_change_password: false            # (Optional) Must change password for owner on first login. Defaults to false
variable "databases" {
  description = <<-EOT
databases:
  <db_ref>:
    name: "db_name"                        # (Required) Name of the database
    create: true                           # (Optional) Whether to create the database. Defaults to true
    create_owner: false                    # (Optional) If the database should be created with an owner. Defaults to false
    owner: "owner_name"                    # (Optional) Owner of the database, required if create_owner is false
    default_collation: "SQL_Latin1_General_CP1_CI_AS" # (Optional) Collation of the database. Defaults to server default
    default_language: "English"            # (Optional) Default language for the owner user
    check_password_expiration: false       # (Optional) Check password expiration for owner. Defaults to false
    check_password_policy: false           # (Optional) Check password policy for owner. Defaults to false
    must_change_password: false            # (Optional) Must change password for owner on first login. Defaults to false
EOT
  type        = any
  default     = {}
}

## Hoop attributes - YAML format
# hoop:
#   enabled: false                           # (Optional) If the hoop should be enabled. Defaults to false
#   agent: "agent_name"                      # (Optional) Name of the hoop agent. Required if enabled is true
#   connection_name: "conn_name"             # (Optional) Name of the hoop connection.
#   db_name: "sqlserver"                     # (Optional) Database name for hoop connection
#   engine: "sqlserver"                     # (Optional) Engine for hoop connection
#   server_name: "server_name"               # (Optional) Logical server name
#   cluster: false                           # (Optional) If it's a cluster
#   port: 1433                               # (Optional) Port for local tunnel. Defaults to 1433
#   username: "user"                         # (Optional) Username for local tunnel
#   password: "pass"                         # (Optional) Password for local tunnel
#   tags:                                    # (Optional) Tags to apply to the hoop. format <tagname>=<tagvalue>
#     - "tag=value"
variable "hoop" {
  description = <<-EOT
hoop:
  enabled: false                           # (Optional) If the hoop should be enabled. Defaults to false
  agent: "agent_name"                      # (Optional) Name of the hoop agent. Required if enabled is true
  connection_name: "conn_name"             # (Optional) Name of the hoop connection.
  db_name: "sqlserver"                     # (Optional) Database name for hoop connection
  engine: "sqlserver"                     # (Optional) Engine for hoop connection
  server_name: "server_name"               # (Optional) Logical server name
  cluster: false                           # (Optional) If it's a cluster
  port: 1433                               # (Optional) Port for local tunnel. Defaults to 1433
  username: "user"                         # (Optional) Username for local tunnel
  password: "pass"                         # (Optional) Password for local tunnel
  tags:                                    # (Optional) Tags to apply to the hoop. format <tagname>=<tagvalue>
    - "tag=value"
EOT
  type        = any
  default     = {}
}

## RDS attributes - YAML format
# rds:
#   enabled: false                           # (Optional) If the RDS should be enabled. Defaults to false
#   name: "rds_instance_id"                  # (Optional) Name of the RDS instance or cluster. Required if enabled is true
#   secret_name: "secret_path"               # (Optional) Name of the AWS Secrets Manager secret. Required if enabled is true
#   cluster: false                           # (Optional) If the RDS is an Aurora RDS Cluster. Defaults to false
#   from_secret: false                       # (Optional) Read all connection details from secret. Defaults to false
#   server_name: "logical_name"              # (Optional) Override server logical name
variable "rds" {
  description = <<-EOT
rds:
  enabled: false                           # (Optional) If the RDS should be enabled. Defaults to false
  name: "rds_instance_id"                  # (Optional) Name of the RDS instance or cluster. Required if enabled is true
  secret_name: "secret_path"               # (Optional) Name of the AWS Secrets Manager secret. Required if enabled is true
  cluster: false                           # (Optional) If the RDS is an Aurora RDS Cluster. Defaults to false
  from_secret: false                       # (Optional) Read all connection details from secret. Defaults to false
  server_name: "logical_name"              # (Optional) Override server logical name
EOT
  type        = any
  default     = {}
}

## Direct attributes - YAML format
# direct:
#   server_name: "server"                    # (Required) Logical server name
#   host: "host_address"                     # (Required) Database host address
#   port: 1433                               # (Required) Database port
#   jump_host: "jump_host"                   # (Optional) Jump host address
#   jump_port: 22                            # (Optional) Jump host port
#   username: "admin"                        # (Optional) Database username
#   password: "password"                     # (Optional) Database password
#   secret_name: "secret_path"               # (Optional) AWS Secrets Manager secret name for credentials
#   engine: "sqlserver"                     # (Optional) Database engine. Defaults to sqlserver
#   db_name: "master"                        # (Optional) Default database name
variable "direct" {
  description = <<-EOT
direct:
  server_name: "server"                    # (Required) Logical server name
  host: "host_address"                     # (Required) Database host address
  port: 1433                               # (Required) Database port
  jump_host: "jump_host"                   # (Optional) Jump host address
  jump_port: 22                            # (Optional) Jump host port
  username: "admin"                        # (Optional) Database username
  password: "password"                     # (Optional) Database password
  secret_name: "secret_path"               # (Optional) AWS Secrets Manager secret name for credentials
  engine: "sqlserver"                     # (Optional) Database engine. Defaults to sqlserver
  db_name: "master"                        # (Optional) Default database name
EOT
  type        = any
  default     = {}
}

variable "password_rotation_period" {
  description = "Password rotation period in days # (Optional) Defaults to 90"
  type        = number
  default     = 90
}

variable "run_hoop" {
  description = "Run hoop with agent, be careful with this option, it will run the HOOP command in output in a null_resource # (Optional) Defaults to false"
  type        = bool
  default     = false
}

variable "secrets_kms_key_id" {
  description = "(optional) KMS Key ID to use to encrypt data in this secret, can be ARN or KMS Alias # (Optional) Defaults to null"
  type        = string
  default     = null
}

variable "rotation_lambda_name" {
  description = "Name of the lambda function to rotate the password # (Optional) Defaults to empty"
  type        = string
  default     = ""
}

variable "rotation_duration" {
  description = "Duration of the lambda function to rotate the password # (Optional) Defaults to 1h"
  type        = string
  default     = "1h"
}

variable "rotate_immediately" {
  description = "Rotate the password immediately # (Optional) Defaults to false"
  type        = bool
  default     = false
}

variable "force_reset" {
  description = "Force Reset the password # (Optional) Defaults to false"
  type        = bool
  default     = false
}