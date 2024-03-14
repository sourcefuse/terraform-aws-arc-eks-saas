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

  values = [
    "${file("values.yaml")}"
  ]

  set = [ {
    name  = "global.prometheus.enabled"
    value = false
  },

  {
    name  = "global.prometheus.fqdn"
    value = ""
  },

  {
    name  = "global.grafana.enabled"
    value = false
  },

  {
    name  = "global.grafana.domainName"
    value = ""
  },

  {
    name  = "global.amp.enabled"
    value = true
  },

  {
    name  = "global.amp.prometheusServerEndpoint"
    value = "http://localhost:8005/workspaces/${data.aws_ssm_parameter.prometheus_workspace_id.value}"
  },

  {
    name  = "global.amp.remoteWriteService"
    value = "https://aps-workspaces.${var.region}.amazonaws.com/workspaces/${data.aws_ssm_parameter.prometheus_workspace_id.value}/api/v1/remote_write"
  },

  {
    name  = "global.amp.sigv4.region"
    value = var.region
  },

  {
    name  = "global.savedReports.enabled"
    value = true
  },

  {
    name  = "global.cloudCostReports.enabled"
    value = true
  },

  {
    name  = "upgrade.toV2"
    value = true
  },

   {
    name  = "sigV4Proxy.region"
    value = var.region
  },

 {
    name  = "sigV4Proxy.host"
    value = "aps-workspaces.${var.region}.amazonaws.com"
  },

  {
    name  = "networkCosts.enabled"
    value = true
  }
  ]

}