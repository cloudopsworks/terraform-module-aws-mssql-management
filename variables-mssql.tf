##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## Users definition - YAML format
#
# A user always has a single server-level login and one database user per
# database it is assigned to. Databases are resolved in this order, and the
# first one is the default: it sets the login's default database and is the
# database recorded in the user's Secrets Manager secret.
#
#   1. database_id   (single, undeclared database - highest precedence)
#   2. db_ref        (single, declared database)
#   3. database_ids  (list, undeclared databases)
#   4. db_refs       (list, declared databases)
#
# `db_ref` and `database_id` are the pre-multi-database attributes and keep
# working unchanged; they now simply denote the first database.
#
# users:
#   <user_ref>:
#     name: "user_name"                      # (Required) Name of the user
#     grant: "owner"                         # (Required) Grant type for the user. Possible values: owner, readwrite, readonly
#     db_ref: "db_reference"                 # (Optional) Reference to a database declared in `databases`. Becomes the user's default database
#     db_refs:                               # (Optional) References to every database declared in `databases` the user is created in. Defaults to []
#       - "db_reference"
#     database_id: "db_id"                   # (Optional) Direct ID of a database not declared in `databases`. Takes precedence over db_ref as the default database
#     database_ids:                          # (Optional) Direct IDs of every undeclared database the user is created in. Defaults to []
#       - "db_id"
#     database_name: "db_name"               # (Optional) Database name used in the secret when the user is attached by database_id only
#     schema: "dbo"                          # (Optional) Schema the readonly/readwrite grant applies to. Defaults to dbo
#     schemas:                               # (Optional) Additional schemas the readonly/readwrite grant applies to, in every assigned database. Defaults to []
#       - "app"
#     connection_string_type: "jdbc"         # (Optional) Emit a connection string in the secret. Possible values: jdbc, jdbc_plain, dotnet, odbc, node, gomssql
#     default_language: "English"            # (Optional) Default language for the user
#     check_password_expiration: false       # (Optional) Check password expiration. Defaults to false
#     check_password_policy: false           # (Optional) Check password policy. Defaults to false
#     must_change_password: false            # (Optional) Must change password on first login. Defaults to false
#     secret:                                # (Optional) Per-user Secrets Manager settings. Module-wide defaults apply when omitted.
#       import: false                        # (Optional) Import the existing Secrets Manager secret. Defaults to false.
#       recovery_window: 30                  # (Optional) Recovery window: 0 or 7-30 days. Defaults to secrets_recovery_window.
#       replica:
#         region: "us-west-2"                # (Optional) Replica region. Defaults to secrets_replica_region.
#         kms_key_id: "alias/key"            # (Optional) Replica-region KMS key. Defaults to secrets_replica_kms_key_id.
#     hoop:                                  # (Optional) Hoop settings for the user
#       access_control: ["group"]            # (Optional) Access control groups merged with hoop.access_control. Defaults to []
variable "users" {
  description = <<-EOT
users:
  <user_ref>:
    name: "user_name"                      # (Required) Name of the user
    grant: "owner"                         # (Required) Grant type for the user. Possible values: owner, readwrite, readonly
    db_ref: "db_reference"                 # (Optional) Reference to a database declared in `databases`. Becomes the user's default database
    db_refs:                               # (Optional) References to every database declared in `databases` the user is created in. Defaults to []
      - "db_reference"
    database_id: "db_id"                   # (Optional) Direct ID of a database not declared in `databases`. Takes precedence over db_ref as the default database
    database_ids:                          # (Optional) Direct IDs of every undeclared database the user is created in. Defaults to []
      - "db_id"
    database_name: "db_name"               # (Optional) Database name used in the secret when the user is attached by database_id only
    schema: "dbo"                          # (Optional) Schema the readonly/readwrite grant applies to. Defaults to dbo
    schemas:                               # (Optional) Additional schemas the readonly/readwrite grant applies to, in every assigned database. Defaults to []
      - "app"
    connection_string_type: "jdbc"         # (Optional) Emit a connection string in the secret. Possible values: jdbc, jdbc_plain, dotnet, odbc, node, gomssql
    default_language: "English"            # (Optional) Default language for the user
    check_password_expiration: false       # (Optional) Check password expiration. Defaults to false
    check_password_policy: false           # (Optional) Check password policy. Defaults to false
    must_change_password: false            # (Optional) Must change password on first login. Defaults to false
    secret:                                # (Optional) Per-user Secrets Manager settings. Module-wide defaults apply when omitted.
      import: false                        # (Optional) Import the existing Secrets Manager secret. Defaults to false.
      recovery_window: 30                  # (Optional) Recovery window: 0 or 7-30 days. Defaults to secrets_recovery_window.
      replica:
        region: "us-west-2"                # (Optional) Replica region. Defaults to secrets_replica_region.
        kms_key_id: "alias/key"            # (Optional) Replica-region KMS key. Defaults to secrets_replica_kms_key_id.
    hoop:                                  # (Optional) Hoop settings for the user
      access_control: ["group"]            # (Optional) Access control groups merged with hoop.access_control. Defaults to []
EOT
  type        = any
  default     = {}

  validation {
    condition = alltrue([
      for key, user in var.users : length(distinct(concat(
        compact([try(user.database_id, "")]), try(user.database_ids, []),
        compact([try(user.db_ref, "")]), try(user.db_refs, [])
        ))) == length(concat(
        compact([try(user.database_id, "")]), try(user.database_ids, []),
        compact([try(user.db_ref, "")]), try(user.db_refs, [])
      ))
    ])
    error_message = "Each user must reference every database at most once across db_ref, db_refs, database_id and database_ids."
  }
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
#
# `schemas` declares the schemas the module creates in each database. SQL Server
# provides `dbo` (the default schema for principals) plus `guest`, `sys` and
# `information_schema` with every database; declaring any of them is accepted
# and resolves to the existing schema instead of creating one.
#
# `global_owner` promotes a single database owner to db_owner of every database
# declared in this variable, so one credential administers all of them. It has
# no effect unless `create_owner` is also true.
#
# databases:
#   <db_ref>:
#     name: "db_name"                        # (Required) Name of the database
#     create: true                           # (Optional) Whether to create the database. Defaults to true
#     create_owner: false                    # (Optional) If the database should be created with an owner. Defaults to false
#     global_owner: false                    # (Optional) Make this database's owner a db_owner of every declared database. Requires create_owner. Defaults to false
#     owner: "owner_name"                    # (Optional) Owner of the database, required if create_owner is false
#     schemas:                               # (Optional) Schemas to create in the database. Defaults to []
#       - "app"                              #            Shorthand form: the schema name
#       - name: "reporting"                  #            (Required) Schema name. `dbo`, `guest`, `sys` and `information_schema` are built in and are never created
#         owner_ref: "user_ref"              #            (Optional) Reference to a user in `users` that owns the schema. The user must be assigned to this database. Defaults to null
#     default_collation: "SQL_Latin1_General_CP1_CI_AS" # (Optional) Collation of the database. Defaults to server default
#     default_language: "English"            # (Optional) Default language for the owner user
#     check_password_expiration: false       # (Optional) Check password expiration for owner. Defaults to false
#     check_password_policy: false           # (Optional) Check password policy for owner. Defaults to false
#     must_change_password: false            # (Optional) Must change password for owner on first login. Defaults to false
#     secret:                                # (Optional) Owner-secret settings, used when create_owner is true.
#       import: false                        # (Optional) Import the existing owner secret. Defaults to false.
#       recovery_window: 30                  # (Optional) Recovery window: 0 or 7-30 days. Defaults to secrets_recovery_window.
#       replica:
#         region: "us-west-2"                # (Optional) Replica region. Defaults to secrets_replica_region.
#         kms_key_id: "alias/key"            # (Optional) Replica-region KMS key. Defaults to secrets_replica_kms_key_id.
variable "databases" {
  description = <<-EOT
databases:
  <db_ref>:
    name: "db_name"                        # (Required) Name of the database
    create: true                           # (Optional) Whether to create the database. Defaults to true
    create_owner: false                    # (Optional) If the database should be created with an owner. Defaults to false
    global_owner: false                    # (Optional) Make this database's owner a db_owner of every declared database. Requires create_owner. Defaults to false
    owner: "owner_name"                    # (Optional) Owner of the database, required if create_owner is false
    schemas:                               # (Optional) Schemas to create in the database. Defaults to []
      - "app"                              #            Shorthand form: the schema name
      - name: "reporting"                  #            (Required) Schema name. `dbo`, `guest`, `sys` and `information_schema` are built in and are never created
        owner_ref: "user_ref"              #            (Optional) Reference to a user in `users` that owns the schema. The user must be assigned to this database. Defaults to null
    default_collation: "SQL_Latin1_General_CP1_CI_AS" # (Optional) Collation of the database. Defaults to server default
    default_language: "English"            # (Optional) Default language for the owner user
    check_password_expiration: false       # (Optional) Check password expiration for owner. Defaults to false
    check_password_policy: false           # (Optional) Check password policy for owner. Defaults to false
    must_change_password: false            # (Optional) Must change password for owner on first login. Defaults to false
    secret:                                # (Optional) Owner-secret settings, used when create_owner is true.
      import: false                        # (Optional) Import the existing owner secret. Defaults to false.
      recovery_window: 30                  # (Optional) Recovery window: 0 or 7-30 days. Defaults to secrets_recovery_window.
      replica:
        region: "us-west-2"                # (Optional) Replica region. Defaults to secrets_replica_region.
        kms_key_id: "alias/key"            # (Optional) Replica-region KMS key. Defaults to secrets_replica_kms_key_id.
EOT
  type        = any
  default     = {}

  validation {
    condition = alltrue([
      for key, db in var.databases : try(db.create_owner, false)
      if try(db.global_owner, false)
    ])
    error_message = "databases.<db_ref>.global_owner requires create_owner to be true - there is no owner login to promote otherwise."
  }

  validation {
    condition = alltrue(flatten([
      for key, db in var.databases : [
        for schema in try(db.schemas, []) : try(schema.name, schema) != ""
      ]
    ]))
    error_message = "Every entry of databases.<db_ref>.schemas must be a non-empty schema name, or an object carrying a non-empty name."
  }
}

## Hoop attributes - YAML format
# hoop:
#   enabled: false                           # (Optional) If the hoop should be enabled. Defaults to false
#   agent_id: "agent-uuid"                   # (Required if enabled) UUID of the Hoop agent.
#   community: true                          # (Optional) Use community secret prefix (_aws:) vs enterprise (_envs/aws#); default: true
#   import: false                            # (Optional) Import existing Hoop connection; default: false
#   tags: {key: "value"}                     # (Optional) Tags map for Hoop connection
#   access_control: ["group"]               # (Optional) Access control groups for Hoop connection
#   engine: "sqlserver"                      # (Optional) Engine for hoop connection
#   server_name: "server_name"              # (Optional) Logical server name
#   cluster: false                           # (Optional) If it's a cluster
#   port: 1433                               # (Optional) Port for local tunnel. Defaults to 1433
#   username: "user"                         # (Optional) Username for local tunnel
#   password: "pass"                         # (Optional) Password for local tunnel
variable "hoop" {
  description = "Hoop connection output settings for terraform-module-hoop-connection - see docs for example"
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

variable "specials_in_password" {
  description = "(optional) Use special characters in generated owner/user passwords. When false, generated passwords are alphanumeric only. Defaults to true"
  type        = bool
  default     = true
}

variable "secrets_recovery_window" {
  description = "(optional) Default recovery window in days before a deleted secret is permanently removed. Use 0 to delete immediately, otherwise 7-30. Defaults to 30"
  type        = number
  default     = 30
  nullable    = false
}

variable "secrets_replica_region" {
  description = "(optional) Region to replicate every managed secret into. When null, no replica is created unless set per entity. Defaults to null"
  type        = string
  default     = null
}

variable "secrets_replica_kms_key_id" {
  description = "(optional) KMS Key ID used to encrypt replicated secrets, can be ARN or KMS Alias. Must reside in the replica region. Defaults to null (AWS managed key)"
  type        = string
  default     = null
}
