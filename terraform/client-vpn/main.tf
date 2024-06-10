################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

################################################################################
## certs
################################################################################
module "self_signed_cert_ca" {
  source = "git::https://github.com/cloudposse/terraform-aws-ssm-tls-self-signed-cert.git?ref=1.3.0"

  enabled    = true
  attributes = ["self", "signed", "cert", "ca"]

  namespace = var.namespace
  stage     = var.environment
  name      = var.client_vpn_name

  secret_path_format = var.secret_path_format

  subject = {
    common_name  = var.common_name
    organization = var.namespace
  }

  basic_constraints = {
    ca = true
  }

  allowed_uses = [
    "crl_signing",
    "cert_signing",
  ]

  certificate_backends = ["SSM"]
}

data "aws_ssm_parameter" "ca_key" {
  name = module.self_signed_cert_ca.certificate_key_path

  depends_on = [
    module.self_signed_cert_ca
  ]
}

module "self_signed_cert_root" {
  source = "git::https://github.com/cloudposse/terraform-aws-ssm-tls-self-signed-cert.git?ref=1.3.0"

  enabled = true

  attributes = ["self", "signed", "cert", "root"]

  namespace = var.namespace
  stage     = var.environment
  name      = var.client_vpn_name

  secret_path_format = var.secret_path_format

  subject = {
    common_name  = var.common_name
    organization = var.namespace
  }

  basic_constraints = {
    ca = false
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]

  certificate_backends = ["ACM", "SSM"]

  use_locally_signed = true

  certificate_chain = {
    cert_pem        = module.self_signed_cert_ca.certificate_pem,
    private_key_pem = join("", data.aws_ssm_parameter.ca_key[*].value)
  }
}
################################################################################
## client vpn configuration
################################################################################
module "vpn" {
  count   = var.enable_client_vpn ? 1 : 0
  source  = "sourcefuse/arc-vpn/aws"
  version = "1.0.0"

  vpc_id                                            = data.aws_vpc.vpc.id
  client_vpn_ingress_rules                          = var.client_vpn_ingress_rules
  authentication_options_type                       = var.authentication_options_type
  authentication_options_root_certificate_chain_arn = module.self_signed_cert_root.certificate_arn

  ## access
  client_vpn_authorize_all_groups = true
  client_vpn_subnet_ids           = data.aws_subnets.private.ids
  client_vpn_target_network_cidr  = data.aws_vpc.vpc.cidr_block

  ## self signed certificate
  create_self_signed_server_cert             = true
  self_signed_server_cert_server_common_name = "*.arc-saas.net"
  self_signed_server_cert_organization_name  = var.namespace
  self_signed_server_cert_ca_pem             = module.self_signed_cert_ca.certificate_pem
  self_signed_server_cert_private_ca_key_pem = join("", data.aws_ssm_parameter.ca_key[*].value)

  ## client vpn
  client_cidr             = cidrsubnet(data.aws_vpc.vpc.cidr_block, 6, 1)
  client_vpn_name         = "${var.namespace}-${var.environment}-client-vpn"
  client_vpn_gateway_name = "${var.namespace}-${var.environment}-vpn-gateway"

  tags = module.tags.tags
}