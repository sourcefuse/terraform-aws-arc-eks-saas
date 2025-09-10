region = "us-east-1"
environment = "dev"
namespace = "saas-demo"
service_account_name         = "grafana-sa"
grafana_helm_release_version = "8.8.5" # Use the latest stable version
grafana_volume_size          = "20Gi"
grafana_service_type         = "NodePort"
domain_name = "arc-saas.net"