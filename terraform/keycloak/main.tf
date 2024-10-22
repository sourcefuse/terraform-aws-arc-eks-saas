###############################################################################
## tags
###############################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

###############################################################################
## keycloak password
###############################################################################
module "keycloak_password" {
  source           = "../../modules/random-password"
  length           = 10
  is_special       = true
  override_special = "!#$%&*=+"
}

###############################################################################
## keycloak helm
###############################################################################
resource "kubernetes_namespace" "keycloak_namespace" {
  metadata {
    name = local.kubernetes_ns

    labels = {
      istio-injection = "enabled"
    }
  }

  lifecycle {
    prevent_destroy = false # Allows Terraform to delete the namespace
  }
}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  namespace  = "${local.kubernetes_ns}"
  chart      = "keycloak"
  version    = "21.7.4"
  repository = "https://charts.bitnami.com/bitnami"

  set {
    name  = "auth.adminUser"
    value = "admin"
  }

  set {
    name  = "auth.adminPassword"
    value = "${module.keycloak_password.result}"
  }

  set {
    name  = "postgresql.enabled"
    value = false
  }

  set {
    name  = "externalDatabase.host"
    value = "${data.aws_ssm_parameter.db_host.value}"
  }

  set {
    name  = "externalDatabase.user"
    value = "${data.aws_ssm_parameter.db_user.value}"
  }

  set {
    name  = "externalDatabase.password"
    value = "${data.aws_ssm_parameter.db_password.value}"
  }

  set {
    name  = "externalDatabase.database"
    value = "${data.aws_ssm_parameter.keycloak_db_name.value}"
  }


  set {
    name  = "proxy"
    value = "edge"
  }

  set {
    name  = "proxyHeaders"
    value = "forwarded"
  }

    set {
    name  = "httpRelativePath"
    value = "/"
  }

values = [
    <<EOF
extraEnvVars:
  - name: PROXY_ADDRESS_FORWARDING
    value: 'true'
  - name: KEYCLOAK_FRONTEND_URL
    value: "https://keycloak.arc-saas.net"
  - name: KEYCLOAK_LOG_LEVEL
    value: "INFO"
  - name: KC_HOSTNAME_ADMIN_URL
    value: "https://keycloak.arc-saas.net"
  - name: KC_HOSTNAME_URL
    value: "https://keycloak.arc-saas.net"
EOF
  ]

  depends_on = [resource.kubernetes_namespace.keycloak_namespace]
}

########################################################################
## Store keycloak in Parameter Store
########################################################################
module "keycloak_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/keycloak_host"
      value       = "keycloak.${var.domain_name}"
      type        = "SecureString"
      overwrite   = "true"
      description = "Keycloak Host"
    },
    {
      name        = "/${var.namespace}/${var.environment}/keycloak_user"
      value       = "admin"
      type        = "SecureString"
      overwrite   = "true"
      description = "Keycloak User"
    },
    {
      name        = "/${var.namespace}/${var.environment}/keycloak_password"
      value       = module.keycloak_password.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Keycloak Password"
    }
  ]
  tags       = module.tags.tags
}


resource "null_resource" "apply_keycloak_manifests" {
  depends_on = [helm_release.keycloak]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/keycloak-manifest-files/keycloak_gateway.yaml --namespace ${local.kubernetes_ns}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/keycloak-manifest-files/keycloak_virtual_service.yaml --namespace ${local.kubernetes_ns}"
  }
}