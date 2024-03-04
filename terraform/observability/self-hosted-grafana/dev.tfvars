region                       = "us-east-1"
environment                  = "dev"
namespace                    = "arc-saas"
grafana_namespace            = "grafana"
service_account_name         = "grafana-sa"
grafana_helm_release_version = "7.3.0" # Use the latest stable version
grafana_volume_size          = "10Gi"
grafana_service_type         = "LoadBalancer"