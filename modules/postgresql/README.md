<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | ~> 1.21 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_postgresql"></a> [postgresql](#provider\_postgresql) | ~> 1.21 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.pg_user_parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.pg_user_password_parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [null_resource.trigger_password_generation](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [postgresql_database.pg_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/database) | resource |
| [postgresql_default_privileges.default_privileges](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_role.pg_users](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [postgresql_schema.pg_schema](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/schema) | resource |
| [random_password.pg_user_passwords](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connect_timeout"></a> [connect\_timeout](#input\_connect\_timeout) | connection timeout of the database | `number` | `15` | no |
| <a name="input_database"></a> [database](#input\_database) | Name of the database | `string` | `"postgres"` | no |
| <a name="input_host"></a> [host](#input\_host) | Database host | `string` | `""` | no |
| <a name="input_parameter_name_prefix"></a> [parameter\_name\_prefix](#input\_parameter\_name\_prefix) | Prefix for the SSM parameter name | `string` | `""` | no |
| <a name="input_password"></a> [password](#input\_password) | Database password | `string` | `""` | no |
| <a name="input_pg_users"></a> [pg\_users](#input\_pg\_users) | n/a | <pre>list(object({<br>    name  = string<br>    login = bool<br>  }))</pre> | `[]` | no |
| <a name="input_port"></a> [port](#input\_port) | Database port | `number` | `5432` | no |
| <a name="input_postgresql_database"></a> [postgresql\_database](#input\_postgresql\_database) | configuration block for postgresql database | <pre>map(object({<br>    db_name = string<br>    //db_owner          = string<br>    template          = optional(string, null)<br>    lc_collate        = optional(string, null)<br>    connection_limit  = optional(string, null)<br>    allow_connections = optional(string, null)<br>  }))</pre> | `{}` | no |
| <a name="input_postgresql_default_privileges"></a> [postgresql\_default\_privileges](#input\_postgresql\_default\_privileges) | configuration block for postgresql default privileges | <pre>map(object({<br>    role        = string<br>    database    = string<br>    schema      = string<br>    owner       = string<br>    object_type = string<br>    privileges  = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_postgresql_schema"></a> [postgresql\_schema](#input\_postgresql\_schema) | configuration block for postgresql schema | <pre>map(object({<br>    schema_name   = string<br>    schema_owner  = optional(string, null)<br>    database      = optional(string, null)<br>    if_not_exists = optional(string, null)<br>    drop_cascade  = optional(string, null)<br><br>    policy = optional(list(object({<br>      usage = optional(string, null)<br>      role  = optional(string, null)<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_sslmode"></a> [sslmode](#input\_sslmode) | sslmode of the database | `string` | `"require"` | no |
| <a name="input_superuser"></a> [superuser](#input\_superuser) | Defines whether the role is a superuser, and therefore can override all access restrictions within the database | `string` | `false` | no |
| <a name="input_username"></a> [username](#input\_username) | User name of the database | `string` | `"is_root"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->