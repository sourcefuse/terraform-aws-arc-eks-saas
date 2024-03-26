region      = "us-east-1"
namespace   = "arc-saas"
environment = "dev"

# oidc_provider_enabled is required to be true for VPC CNI addon
oidc_provider_enabled        = true
apply_config_map_aws_auth    = true
enabled_cluster_log_types    = ["audit", "api"]
cluster_log_retention_period = 7
instance_types               = ["t3.medium"]
desired_size                 = 5
max_size                     = 6
min_size                     = 3


# When updating the Kubernetes version, also update the API and client-go version in test/src/go.mod
kubernetes_version = "1.28"

map_additional_iam_users = []


addons = [
  // https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html#vpc-cni-latest-available-version
  {
    addon_name                  = "vpc-cni"
    addon_version               = null
    resolve_conflicts_on_create = "NONE"
    resolve_conflicts_on_update = "NONE"
    service_account_role_arn    = null
  },
  // https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html
  {
    addon_name                  = "kube-proxy"
    addon_version               = null
    resolve_conflicts_on_create = "NONE"
    resolve_conflicts_on_update = "NONE"
    service_account_role_arn    = null
  }
]

##################################################################################
#ADD-ON VARIABLES
##################################################################################
eks_addons_timeouts                          = {}
enable_aws_load_balancer_controller          = true
enable_cluster_proportional_autoscaler       = false
enable_karpenter                             = false
enable_kube_prometheus_stack                 = false
enable_metrics_server                        = true
enable_external_dns                          = false
external_dns_route53_zone_arns               = []
enable_argocd                                = true
enable_argo_rollouts                         = false
enable_argo_workflows                        = false
enable_cluster_autoscaler                    = false
enable_aws_cloudwatch_metrics                = false
external_secrets_ssm_parameter_arns          = []
external_secrets_secrets_manager_arns        = []
enable_ingress_nginx                         = false
enable_aws_privateca_issuer                  = false
enable_velero                                = false
enable_aws_for_fluentbit                     = true
enable_external_secrets                      = false
enable_aws_node_termination_handler          = false
enable_cert_manager                          = false
enable_aws_efs_csi_driver                    = false
enable_aws_fsx_csi_driver                    = false
enable_secrets_store_csi_driver              = true
enable_secrets_store_csi_driver_provider_aws = true
enable_fargate_fluentbit                     = false
external_secrets_kms_key_arns                = []
enable_gatekeeper                            = false
enable_vpa                                   = false

