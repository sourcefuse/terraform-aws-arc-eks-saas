################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

#################################################################################
## Tag public subnets, Required for load balancer controller addon
#################################################################################
resource "aws_ec2_tag" "alb_tag" {
  for_each    = toset(data.aws_subnets.public.ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

#################################################################################
## EKS cluster
#################################################################################
module "eks_cluster" {
  source                               = "sourcefuse/arc-eks/aws"
  version                              = "5.0.10"
  environment                          = var.environment
  name                                 = "eks"
  namespace                            = var.namespace
  region                               = var.region
  desired_size                         = var.desired_size
  instance_types                       = var.instance_types
  kubernetes_namespace                 = var.kubernetes_namespace
  create_node_group                    = true
  max_size                             = var.max_size
  min_size                             = var.min_size
  subnet_ids                           = data.aws_subnets.private.ids
  vpc_id                               = data.aws_vpc.vpc.id
  enabled                              = true
  kubernetes_version                   = var.kubernetes_version
  apply_config_map_aws_auth            = var.apply_config_map_aws_auth
  kube_data_auth_enabled               = true
  kube_exec_auth_enabled               = true
  enabled_cluster_log_types            = var.enabled_cluster_log_types
  cluster_log_retention_period         = var.cluster_log_retention_period
  oidc_provider_enabled                = var.oidc_provider_enabled
  local_exec_interpreter               = var.local_exec_interpreter
  kubernetes_labels                    = var.kubernetes_labels
  cluster_encryption_config_enabled    = var.cluster_encryption_config_enabled
  cluster_encryption_config_kms_key_id = var.cluster_encryption_config_kms_key_id
  addons                               = var.addons
  map_additional_iam_roles = [
    {
      username = "admin",
      groups   = ["system:masters"],
      rolearn  = data.aws_ssm_parameter.codebuild_role.value
    }
  ]
  map_additional_iam_users = var.map_additional_iam_users
  allowed_cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
}

#################################################################################
## EKS Add-On
#################################################################################
module "eks_blueprints_addons" {
  source            = "aws-ia/eks-blueprints-addons/aws"
  version           = "1.16.3"
  cluster_name      = module.eks_cluster.eks_cluster_id
  cluster_endpoint  = module.eks_cluster.eks_cluster_endpoint
  cluster_version   = module.eks_cluster.eks_cluster_version
  oidc_provider_arn = module.eks_cluster.eks_oidc_issuer_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }

  }


  eks_addons_timeouts                          = var.eks_addons_timeouts
  enable_aws_load_balancer_controller          = var.enable_aws_load_balancer_controller
  aws_load_balancer_controller                 = var.aws_load_balancer_controller
  enable_cluster_proportional_autoscaler       = var.enable_cluster_proportional_autoscaler
  cluster_proportional_autoscaler              = var.cluster_proportional_autoscaler
  karpenter                                    = var.karpenter
  karpenter_enable_spot_termination            = var.karpenter_enable_spot_termination
  karpenter_sqs                                = var.karpenter_sqs
  karpenter_node                               = var.karpenter_node
  enable_karpenter                             = var.enable_karpenter
  enable_kube_prometheus_stack                 = var.enable_kube_prometheus_stack
  kube_prometheus_stack                        = var.kube_prometheus_stack
  metrics_server                               = var.metrics_server
  enable_metrics_server                        = var.enable_metrics_server
  enable_external_dns                          = var.enable_external_dns
  external_dns                                 = var.external_dns
  external_dns_route53_zone_arns               = var.external_dns_route53_zone_arns
  enable_external_secrets                      = var.enable_external_secrets
  external_secrets                             = var.external_secrets
  enable_argocd                                = var.enable_argocd
  argocd                                       = var.argocd
  argo_rollouts                                = var.argo_rollouts
  enable_argo_rollouts                         = var.enable_argo_rollouts
  argo_workflows                               = var.argo_workflows
  enable_argo_workflows                        = var.enable_argo_workflows
  cluster_autoscaler                           = var.cluster_autoscaler
  enable_cluster_autoscaler                    = var.enable_cluster_autoscaler
  enable_aws_cloudwatch_metrics                = var.enable_aws_cloudwatch_metrics
  aws_cloudwatch_metrics                       = var.aws_cloudwatch_metrics
  external_secrets_ssm_parameter_arns          = var.external_secrets_ssm_parameter_arns
  external_secrets_secrets_manager_arns        = var.external_secrets_secrets_manager_arns
  ingress_nginx                                = var.ingress_nginx
  enable_ingress_nginx                         = var.enable_ingress_nginx
  aws_privateca_issuer                         = var.aws_privateca_issuer
  enable_aws_privateca_issuer                  = var.enable_aws_privateca_issuer
  velero                                       = var.velero
  enable_velero                                = var.enable_velero
  aws_for_fluentbit                            = var.aws_for_fluentbit
  enable_aws_for_fluentbit                     = var.enable_aws_for_fluentbit
  aws_for_fluentbit_cw_log_group               = var.aws_for_fluentbit_cw_log_group
  enable_aws_node_termination_handler          = var.enable_aws_node_termination_handler
  aws_node_termination_handler                 = var.aws_node_termination_handler
  aws_node_termination_handler_sqs             = var.aws_node_termination_handler_sqs
  aws_node_termination_handler_asg_arns        = var.aws_node_termination_handler_asg_arns
  cert_manager                                 = var.cert_manager
  enable_cert_manager                          = var.enable_cert_manager
  cert_manager_route53_hosted_zone_arns        = var.cert_manager_route53_hosted_zone_arns
  enable_aws_efs_csi_driver                    = var.enable_aws_efs_csi_driver
  aws_efs_csi_driver                           = var.aws_efs_csi_driver
  aws_fsx_csi_driver                           = var.aws_fsx_csi_driver
  enable_aws_fsx_csi_driver                    = var.enable_aws_fsx_csi_driver
  secrets_store_csi_driver                     = var.secrets_store_csi_driver
  secrets_store_csi_driver_provider_aws        = var.secrets_store_csi_driver_provider_aws
  enable_fargate_fluentbit                     = var.enable_fargate_fluentbit
  fargate_fluentbit                            = var.fargate_fluentbit
  enable_secrets_store_csi_driver_provider_aws = var.enable_secrets_store_csi_driver_provider_aws
  enable_secrets_store_csi_driver              = var.enable_secrets_store_csi_driver
  external_secrets_kms_key_arns                = var.external_secrets_kms_key_arns
  enable_gatekeeper                            = var.enable_gatekeeper
  gatekeeper                                   = var.gatekeeper
  fargate_fluentbit_cw_log_group               = var.fargate_fluentbit_cw_log_group
  vpa                                          = var.vpa
  enable_vpa                                   = var.enable_vpa
  tags                                         = module.tags.tags


  depends_on = [module.eks_cluster]
}

#################################################################################
## Store Karpenter Role ARN in SSM
#################################################################################
module "karpenter_role_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  count  = var.add_role_to_ssm ? 1 : 0
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/karpenter_role"
      value       = module.eks_blueprints_addons.karpenter.node_iam_role_name
      type        = "String"
      overwrite   = "true"
      description = "Karpenter Role ARN"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.eks_cluster, module.eks_blueprints_addons]
}

###################################################################################
## Provide Access to fluentbit role
###################################################################################
resource "aws_iam_role_policy_attachment" "fluentbit_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonOpenSearchServiceFullAccess"
  role       = module.eks_blueprints_addons.aws_for_fluentbit.iam_role_name
}

module "fluentbit_role_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/fluentbit_role"
      value       = module.eks_blueprints_addons.aws_for_fluentbit.iam_role_arn
      type        = "SecureString"
      overwrite   = "true"
      description = "FluentBit Role ARN"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.eks_cluster, module.eks_blueprints_addons]
}

###################################################################################
## Attach Policy to worker node Role
###################################################################################
resource "aws_iam_role_policy_attachment" "worker_node_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = "${var.namespace}-${var.environment}-eks-workers"

  depends_on = [module.eks_cluster, module.eks_blueprints_addons]
}