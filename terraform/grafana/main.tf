resource "helm_release" "prometheus_blackbox_exporter" {

  name             = "prometheus-blackbox-exporter"
  repository       = "https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-blackbox-exporter"
  chart            = "prometheus-community/prometheus-blackbox-exporter"
  version          = "prometheus-blackbox-exporter-8.12.0"
  namespace        = "kubecost"
  create_namespace = false

  values = [data.template_file.kubecost_helm_value_template.rendered]

}