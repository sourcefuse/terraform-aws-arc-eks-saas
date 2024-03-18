resource "helm_release" "prometheus_blackbox_exporter" {

  name             = "prometheus-blackbox-exporter"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus-blackbox-exporter"
  version          = "prometheus-blackbox-exporter-8.12.0"
  namespace        = "kubecost"
  create_namespace = false

  values = [data.template_file.kubecost_helm_value_template.rendered]

}