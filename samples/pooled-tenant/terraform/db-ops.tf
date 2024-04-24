provider "postgresql" {
  host      = data.aws_ssm_parameter.db_host.value
  port      = data.aws_ssm_parameter.db_port.value
  database  = "user"
  username  = data.aws_ssm_parameter.db_user.value
  password  = data.aws_ssm_parameter.db_password.value
  sslmode   = "require"
  superuser = false
}

resource "random_string" "uuid" {
  length  = 36
  special = false
}

data "postgresql_query" "seed_user" {
  count = var.first_pooled_user ? 0 : 1
  database = "user"
  query = <<-EOF
    SET search_path TO main, public;

INSERT INTO main.auth_clients(client_id, client_secret, redirect_url, access_token_expiration, refresh_token_expiration, auth_code_expiration, secret)
    VALUES ('${var.tenant_client_id}', '${var.tenant_client_secret}', 'https://${var.tenant_host_domain}/main/home', '900', '3600', '300', '${var.tenant_secret}');

INSERT INTO tenants(name, status, key)
    VALUES ('${var.tenant_name}', 0, '${var.tenant}');

INSERT INTO roles(name, permissions, role_type, tenant_id)
    VALUES ('SuperAdmin', '{CreateTenant,ViewTenant,UpdateTenant,DeleteTenant,CreateTenantUser,10200,10201,10202,10203,10204,10216,10205,10206,10207,10208,10209,10210,10211,10212,10213,10214,10215,2,7008,8000,8001,8002,8003,7001,7002,7003,7004,7005,7006,7007,7008,7009,7010,7011,7012,7013,7014,7015,7016,7017,7018,7019,7020,7021,7022,7023,7024,7025,7026,7027,7028}', 0,(
            SELECT
                id
            FROM
                main.tenants
            WHERE
                key = '${var.tenant}'));

INSERT INTO main.users(first_name, last_name, username, email, default_tenant_id)

SELECT '${var.user_name}',
'',
'${var.tenant_email}', 
'${var.tenant_email}',
 id
FROM
    main.tenants
WHERE
    key = '${var.tenant}';

INSERT INTO main.user_tenants(id, user_id, tenant_id, status, role_id)
SELECT
        '${random_string.uuid.result}',
(
        SELECT
            id
        FROM
            main.users
        WHERE
            email = '${var.tenant_email}'),(
        SELECT
            id
        FROM
            main.tenants
        WHERE
            key = '${var.tenant}'), 1, id
FROM
    roles
WHERE
    role_type = 0;

INSERT INTO main.user_credentials(auth_id, auth_provider, user_id)

SELECT '${aws_cognito_user.cognito_user.sub}', 'aws-cognito', id FROM main.users WHERE email = '${var.tenant_email}';  

update main.users set auth_client_ids = ARRAY[(select id from main.auth_clients where client_id = '${var.tenant_client_id}')::integer];  
  EOF
}


#######################################################################
## pooled tenant db user
#######################################################################
module "tenant_db_password" {
  source           = "../modules/random-password"
  length           = 16
  is_special       = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "postgresql_role" "db_user" {
  name     = ${var.tenant}
  login    = true
  password = module.tenant_db_password.result
}

module "db_ssm_parameters" {
  source = "../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/pooled-${var.tenant}/db_user"
      value       = ${var.tenant}
      type        = "String"
      overwrite   = "true"
      description = "Database User Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled-${var.tenant}/db_password"
      value       = module.tenant_db_password.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Password"
    }
  ]
  tags = module.tags.tags
}