region = "us-west-2"
environment = "dev"
namespace = "sf-arc-saas"
service_account_name         = "grafana-sa"
grafana_helm_release_version = "7.3.0" # Use the latest stable version
grafana_volume_size          = "20Gi"
grafana_service_type         = "NodePort"
domain_name = "arc-saas.net"