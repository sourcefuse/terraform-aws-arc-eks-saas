############################################################################
## default
############################################################################
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.24.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
    }
  }

  backend "s3" {}

}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

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
  source  = "cloudposse/eks-cluster/aws"
  version = "3.0.0"

  //stage              = var.environment
  vpc_id             = data.aws_vpc.vpc.id
  subnet_ids         = concat(data.aws_subnets.private.ids, data.aws_subnets.public.ids)
  kubernetes_version = var.kubernetes_version

  local_exec_interpreter                    = var.local_exec_interpreter
  oidc_provider_enabled                     = var.oidc_provider_enabled
  enabled_cluster_log_types                 = var.enabled_cluster_log_types
  cluster_log_retention_period              = var.cluster_log_retention_period
  kubernetes_config_map_ignore_role_changes = var.kubernetes_config_map_ignore_role_changes
  map_additional_iam_roles = [
    {
      username = "admin",
      groups   = ["system:masters"],
      rolearn  = data.aws_ssm_parameter.codebuild_role.value
    }
  ]
  map_additional_iam_users                                  = var.map_additional_iam_users
  cluster_encryption_config_enabled                         = var.cluster_encryption_config_enabled
  cluster_encryption_config_kms_key_id                      = var.cluster_encryption_config_kms_key_id
  cluster_encryption_config_kms_key_enable_key_rotation     = var.cluster_encryption_config_kms_key_enable_key_rotation
  cluster_encryption_config_kms_key_deletion_window_in_days = var.cluster_encryption_config_kms_key_deletion_window_in_days
  cluster_encryption_config_kms_key_policy                  = var.cluster_encryption_config_kms_key_policy
  cluster_encryption_config_resources                       = var.cluster_encryption_config_resources

  addons = var.addons
  //addons_depends_on = [module.eks_node_group]

  # We need to create a new Security Group only if the EKS cluster is used with unmanaged worker nodes.
  # EKS creates a managed Security Group for the cluster automatically, places the control plane and managed nodes into the security group,
  # and allows all communications between the control plane and the managed worker nodes
  # (EKS applies it to ENIs that are attached to EKS Control Plane master nodes and to any managed workloads).
  # If only Managed Node Groups are used, we don't need to create a separate Security Group;
  # otherwise we place the cluster in two SGs - one that is created by EKS, the other one that the module creates.
  # See https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html for more details.
  create_security_group = var.create_security_group

  # This is to test `allowed_security_group_ids` and `allowed_cidr_blocks`
  # In a real cluster, these should be some other (existing) Security Groups and CIDR blocks to allow access to the cluster
  //allowed_security_group_ids = [] 
  allowed_cidr_blocks = [data.aws_vpc.vpc.cidr_block]

  # For manual testing. In particular, set `false` if local configuration/state
  # has a cluster but the cluster was deleted by nightly cleanup, in order for
  # `terraform destroy` to succeed.
  apply_config_map_aws_auth = var.apply_config_map_aws_auth

  context = module.this.context
}

#################################################################################
## EKS Node Group
#################################################################################
module "eks_node_group" {
  source  = "cloudposse/eks-node-group/aws"
  version = "2.12.0"

  //stage             = var.environment
  subnet_ids        = data.aws_subnets.private.ids
  cluster_name      = module.eks_cluster.eks_cluster_id
  instance_types    = var.instance_types
  desired_size      = var.desired_size
  min_size          = var.min_size
  max_size          = var.max_size
  kubernetes_labels = var.kubernetes_labels

  # Prevent the node groups from being created before the Kubernetes aws-auth ConfigMap
  module_depends_on = module.eks_cluster.kubernetes_config_map_id

  context = module.this.context
}

#################################################################################
## EKS Add-On
#################################################################################
module "eks_blueprints_addons" {
  source            = "aws-ia/eks-blueprints-addons/aws"
  version           = "1.13.0"
  cluster_name      = module.eks_cluster.eks_cluster_id
  cluster_endpoint  = module.eks_cluster.eks_cluster_endpoint
  cluster_version   = module.eks_cluster.eks_cluster_version
  oidc_provider_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn

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


  depends_on = [module.eks_cluster, module.eks_node_group]
}

#################################################################################
## Store Karpenter Role ARN in SSM
#################################################################################
module "karpenter_role_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  count = var.add_role_to_ssm ? 1 : 0
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
  depends_on = [module.eks_cluster, module.eks_node_group, module.eks_blueprints_addons]
}