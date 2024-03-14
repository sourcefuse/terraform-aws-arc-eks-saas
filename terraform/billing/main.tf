################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

######################################################################
## KubeCost
######################################################################
resource "helm_release" "kubecost" {

  name             = "kubecost"
  repository       = "https://kubecost.github.io/cost-analyzer"
  chart            = "cost-analyzer"
  version          = "2.0.0"
  namespace        = "kubecost"
  create_namespace = true

  set {
    name  = "global.prometheus.enabled"
    value = false
  }

  set {
    name  = "global.prometheus.fqdn"
    value = ""
  }

  set {
    name  = "global.grafana.enabled"
    value = false
  }

  set {
    name  = "global.grafana.domainName"
    value = ""
  }

  set {
    name  = "global.amp.enabled"
    value = true
  }

  set {
    name  = "global.amp.prometheusServerEndpoint"
    value = "http://localhost:8005/workspaces/${data.aws_ssm_parameter.prometheus_workspace_id.value}"
  }

  set {
    name  = "global.amp.remoteWriteService"
    value = "https://aps-workspaces.${var.region}.amazonaws.com/workspaces/${data.aws_ssm_parameter.prometheus_workspace_id.value}/api/v1/remote_write"
  }

  set {
    name  = "global.amp.sigv4.region"
    value = var.region
  }

  set {
    name  = "global.savedReports.enabled"
    value = true
  }

  set {
    name  = "global.cloudCostReports.enabled"
    value = true
  }

  set {
    name  = "global.upgrade.toV2"
    value = false
  }

  set {
    name  = "global.sigV4Proxy.region"
    value = var.region
  }

  set {
    name  = "global.sigV4Proxy.host"
    value = "aps-workspaces.${var.region}.amazonaws.com"
  }

  set {
    name  = "networkCosts.enabled"
    value = true
  }


}