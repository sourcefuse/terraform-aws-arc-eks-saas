################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}
################################################################################
## EKS
################################################################################
variable "kubernetes_version" {
  type        = string
  default     = "1.29"
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["audit", "api"]
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}

variable "cluster_log_retention_period" {
  type        = number
  default     = 0
  description = "Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html."
}

variable "map_additional_iam_roles" {
  description = "Additional IAM roles to add to `config-map-aws-auth` ConfigMap"

  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "map_additional_iam_users" {
  description = "Additional IAM users to add to `config-map-aws-auth` ConfigMap"

  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "oidc_provider_enabled" {
  type        = bool
  default     = true
  description = "Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using `kiam` or `kube2iam`. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html"
}

variable "local_exec_interpreter" {
  type        = list(string)
  default     = ["/bin/bash", "-c"]
  description = "shell to use for local_exec"
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "Set of instance types associated with the EKS Node Group. Defaults to [\"t3.medium\"]. Terraform will only perform drift detection if a configuration value is provided"
}

variable "kubernetes_labels" {
  type        = map(string)
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
  default     = {}
}

variable "desired_size" {
  type        = number
  default     = 3
  description = "Desired number of worker nodes"
}

variable "max_size" {
  type        = number
  default     = 3
  description = "The maximum size of the AutoScaling Group"
}

variable "min_size" {
  type        = number
  default     = 3
  description = "The minimum size of the AutoScaling Group"
}

variable "cluster_encryption_config_enabled" {
  type        = bool
  default     = false
  description = "Set to `true` to enable Cluster Encryption Configuration"
}


variable "cluster_encryption_config_kms_key_id" {
  type        = string
  default     = ""
  description = "KMS Key ID to use for cluster encryption config"
}

variable "cluster_encryption_config_kms_key_enable_key_rotation" {
  type        = bool
  default     = true
  description = "Cluster Encryption Config KMS Key Resource argument - enable kms key rotation"
}

variable "cluster_encryption_config_kms_key_deletion_window_in_days" {
  type        = number
  default     = 10
  description = "Cluster Encryption Config KMS Key Resource argument - key deletion windows in days post destruction"
}

variable "cluster_encryption_config_kms_key_policy" {
  type        = string
  default     = null
  description = "Cluster Encryption Config KMS Key Resource argument - key policy"
}

variable "cluster_encryption_config_resources" {
  type        = list(any)
  default     = ["secrets"]
  description = "Cluster Encryption Config Resources to encrypt, e.g. ['secrets']"
}

variable "addons" {
  type = list(object({
    addon_name    = string
    addon_version = string

    resolve_conflicts_on_create = string
    resolve_conflicts_on_update = string
    service_account_role_arn    = string
  }))
  default     = []
  description = "Manages [`aws_eks_addon`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) resources."
}

variable "apply_config_map_aws_auth" {
  type        = bool
  default     = true
  description = "Whether to apply the ConfigMap to allow worker nodes to join the EKS cluster and allow additional users, accounts and roles to acces the cluster"
}

variable "kubernetes_namespace" {
  description = "Default k8s namespace to create"
  type        = string
  default     = "arc"
}
################################################################################
# Argo Rollouts
################################################################################

variable "enable_argo_rollouts" {
  description = "Enable Argo Rollouts add-on"
  type        = bool
  default     = false
}

variable "argo_rollouts" {
  description = "Argo Rollouts addon configuration values"
  type        = any
  default     = {}
}

################################################################################
# Argo Workflows
################################################################################

variable "enable_argo_workflows" {
  description = "Enable Argo workflows add-on"
  type        = bool
  default     = true
}

variable "argo_workflows" {
  description = "Argo Workflows addon configuration values"
  type        = any
  default = {
    chart_version = "0.36.1"

    set = [
      {
        name  = "server.authMode"
        value = "server"
      }
    ]
  }
}

################################################################################
# ArgoCD
################################################################################

variable "enable_argocd" {
  description = "Enable Argo CD Kubernetes add-on"
  type        = bool
  default     = true
}

variable "argocd" {
  description = "ArgoCD addon configuration values"
  type        = any
  default = {
    set = [
      {
        name  = "server.extraArgs"
        value = "{--insecure}"
      }
  ] }
}


################################################################################
# AWS Cloudwatch Metrics
################################################################################

variable "enable_aws_cloudwatch_metrics" {
  description = "Enable AWS Cloudwatch Metrics add-on for Container Insights"
  type        = bool
  default     = false
}

variable "aws_cloudwatch_metrics" {
  description = "Cloudwatch Metrics addon configuration values"
  type        = any
  default     = {}
}

################################################################################
# AWS EFS CSI Driver
################################################################################

variable "enable_aws_efs_csi_driver" {
  description = "Enable AWS EFS CSI Driver add-on"
  type        = bool
  default     = false
}

variable "aws_efs_csi_driver" {
  description = "EFS CSI Driver addon configuration values"
  type        = any
  default     = {}
}

################################################################################
# AWS for Fluentbit
################################################################################

variable "enable_aws_for_fluentbit" {
  description = "Enable AWS for FluentBit add-on"
  type        = bool
  default     = true
}

variable "aws_for_fluentbit" {
  description = "AWS Fluentbit add-on configurations"
  type        = any
  default = {
    set = [
      {
        name  = "tolerations[0].operator"
        value = "Exists"
      },
      {
        name  = "cloudWatchLogs.autoCreateGroup"
        value = true
    }]
  }
}

variable "aws_for_fluentbit_cw_log_group" {
  description = "AWS Fluentbit CloudWatch Log Group configurations"
  type        = any
  default     = {}
}


################################################################################
# AWS FSx CSI Driver
################################################################################

variable "enable_aws_fsx_csi_driver" {
  description = "Enable AWS FSX CSI Driver add-on"
  type        = bool
  default     = false
}

variable "aws_fsx_csi_driver" {
  description = "FSX CSI Driver addon configuration values"
  type        = any
  default     = {}
}

################################################################################
# AWS Load Balancer Controller
################################################################################

variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller add-on"
  type        = bool
  default     = true
}

variable "aws_load_balancer_controller" {
  description = "AWS Load Balancer Controller addon configuration values"
  type        = any
  default     = {}
}


################################################################################
# AWS Node Termination Handler
################################################################################

variable "enable_aws_node_termination_handler" {
  description = "Enable AWS Node Termination Handler add-on"
  type        = bool
  default     = false
}

variable "aws_node_termination_handler" {
  description = "AWS Node Termination Handler addon configuration values"
  type        = any
  default     = {}
}

variable "aws_node_termination_handler_sqs" {
  description = "AWS Node Termination Handler SQS queue configuration values"
  type        = any
  default     = {}
}

variable "aws_node_termination_handler_asg_arns" {
  description = "List of Auto Scaling group ARNs that AWS Node Termination Handler will monitor for EC2 events"
  type        = list(string)
  default     = []
}

################################################################################
# AWS Private CA Issuer
################################################################################

variable "enable_aws_privateca_issuer" {
  description = "Enable AWS PCA Issuer"
  type        = bool
  default     = false
}

variable "aws_privateca_issuer" {
  description = "AWS PCA Issuer add-on configurations"
  type        = any
  default     = {}
}

################################################################################
# Cert Manager
################################################################################

variable "enable_cert_manager" {
  description = "Enable cert-manager add-on"
  type        = bool
  default     = false
}

variable "cert_manager" {
  description = "cert-manager addon configuration values"
  type        = any
  default     = {}
}

variable "cert_manager_route53_hosted_zone_arns" {
  description = "List of Route53 Hosted Zone ARNs that are used by cert-manager to create DNS records"
  type        = list(string)
  default     = ["arn:aws:route53:::hostedzone/*"]
}

################################################################################
# Cluster Autoscaler
################################################################################

variable "enable_cluster_autoscaler" {
  description = "Enable Cluster autoscaler add-on"
  type        = bool
  default     = false
}

variable "cluster_autoscaler" {
  description = "Cluster Autoscaler addon configuration values"
  type        = any
  default     = {}
}

################################################################################
# Cluster Proportional Autoscaler
################################################################################

variable "enable_cluster_proportional_autoscaler" {
  description = "Enable Cluster Proportional Autoscaler"
  type        = bool
  default     = false
}

variable "cluster_proportional_autoscaler" {
  description = "Cluster Proportional Autoscaler add-on configurations"
  type        = any
  default     = {}
}

################################################################################
# EKS Addons
################################################################################


variable "eks_addons_timeouts" {
  description = "Create, update, and delete timeout configurations for the EKS addons"
  type        = map(string)
  default     = {}
}

################################################################################
# External DNS
################################################################################

variable "enable_external_dns" {
  description = "Enable external-dns operator add-on"
  type        = bool
  default     = true
}

variable "external_dns" {
  description = "external-dns addon configuration values"
  type        = any
  default = {
    set = [
      {
        name  = "sources[0]"
        value = "service"
      },
      {
        name  = "sources[1]"
        value = "ingress"
      },
      {
        name  = "sources[2]"
        value = "istio-virtualservice"
      },
      {
        name  = "sources[3]"
        value = "istio-gateway"
      },
      {
        name  = "domainFilters[0]"
        value = "*"
      }
  ] }
}

variable "external_dns_route53_zone_arns" {
  description = "List of Route53 zones ARNs which external-dns will have access to create/manage records (if using Route53)"
  type        = list(string)
  default     = []
}

################################################################################
# External Secrets
################################################################################

variable "enable_external_secrets" {
  description = "Enable External Secrets operator add-on"
  type        = bool
  default     = true
}

variable "external_secrets" {
  description = "External Secrets addon configuration values"
  type        = any
  default     = {}
}

variable "external_secrets_ssm_parameter_arns" {
  description = "List of Systems Manager Parameter ARNs that contain secrets to mount using External Secrets"
  type        = list(string)
  default     = ["arn:aws:ssm:*:*:parameter/*"]
}

variable "external_secrets_secrets_manager_arns" {
  description = "List of Secrets Manager ARNs that contain secrets to mount using External Secrets"
  type        = list(string)
  default     = ["arn:aws:secretsmanager:*:*:secret:*"]
}

variable "external_secrets_kms_key_arns" {
  description = "List of KMS Key ARNs that are used by Secrets Manager that contain secrets to mount using External Secrets"
  type        = list(string)
  default     = ["arn:aws:kms:*:*:key/*"]
}

################################################################################
# Fargate Fluentbit
################################################################################

variable "enable_fargate_fluentbit" {
  description = "Enable Fargate FluentBit add-on"
  type        = bool
  default     = false
}

variable "fargate_fluentbit_cw_log_group" {
  description = "AWS Fargate Fluentbit CloudWatch Log Group configurations"
  type        = any
  default     = {}
}

variable "fargate_fluentbit" {
  description = "Fargate fluentbit add-on config"
  type        = any
  default     = {}
}

################################################################################
# Gatekeeper
################################################################################

variable "enable_gatekeeper" {
  description = "Enable Gatekeeper add-on"
  type        = bool
  default     = false
}

variable "gatekeeper" {
  description = "Gatekeeper add-on configuration"
  type        = any
  default     = {}
}

################################################################################
# Ingress Nginx
################################################################################

variable "enable_ingress_nginx" {
  description = "Enable Ingress Nginx"
  type        = bool
  default     = false
}

variable "ingress_nginx" {
  description = "Ingress Nginx add-on configurations"
  type        = any
  default     = {}
}

################################################################################
# Karpenter
################################################################################

variable "enable_karpenter" {
  description = "Enable Karpenter controller add-on"
  type        = bool
  default     = false
}

variable "karpenter" {
  description = "Karpenter addon configuration values"
  type        = any
  default = {
    chart_version = "0.36.2"
  }
}

variable "karpenter_enable_spot_termination" {
  description = "Determines whether to enable native node termination handling"
  type        = bool
  default     = true
}

variable "karpenter_sqs" {
  description = "Karpenter SQS queue for native node termination handling configuration values"
  type        = any
  default     = {}
}

variable "karpenter_node" {
  description = "Karpenter IAM role and IAM instance profile configuration values"
  type        = any
  default     = {}
}

################################################################################
# Kube Prometheus Stack
################################################################################

variable "enable_kube_prometheus_stack" {
  description = "Enable Kube Prometheus Stack"
  type        = bool
  default     = true
}

variable "kube_prometheus_stack" {
  description = "Kube Prometheus Stack add-on configurations"
  type        = any
  default     = {}
}

################################################################################
# Metrics Server
################################################################################

variable "enable_metrics_server" {
  description = "Enable metrics server add-on"
  type        = bool
  default     = true
}

variable "metrics_server" {
  description = "Metrics Server add-on configurations"
  type        = any
  default     = {}
}

################################################################################
# Secrets Store CSI Driver
################################################################################

variable "enable_secrets_store_csi_driver" {
  description = "Enable CSI Secrets Store Provider"
  type        = bool
  default     = true
}

variable "secrets_store_csi_driver" {
  description = "CSI Secrets Store Provider add-on configurations"
  type        = any
  default = {
    set = [{
      name  = "syncSecret.enabled"
      value = "true"
    }]
  }
}

################################################################################
# CSI Secrets Store Provider AWS
################################################################################

variable "enable_secrets_store_csi_driver_provider_aws" {
  description = "Enable AWS CSI Secrets Store Provider"
  type        = bool
  default     = true
}

variable "secrets_store_csi_driver_provider_aws" {
  description = "CSI Secrets Store Provider add-on configurations"
  type        = any
  default = {
    set = [
      {
        name  = "tolerations[0].operator"
        value = "Exists"
      },
      {
        name  = "cloudWatchLogs.autoCreateGroup"
        value = true
    }]
  }
}

################################################################################
# Velero
################################################################################

variable "enable_velero" {
  description = "Enable Kubernetes Dashboard add-on"
  type        = bool
  default     = false
}

variable "velero" {
  description = "Velero addon configuration values"
  type        = any
  default     = {}
}

################################################################################
# Vertical Pod Autoscaler
################################################################################

variable "enable_vpa" {
  description = "Enable Vertical Pod Autoscaler add-on"
  type        = bool
  default     = false
}

variable "vpa" {
  description = "Vertical Pod Autoscaler addon configuration values"
  type        = any
  default     = {}
}

variable "add_role_to_ssm" {
  type        = bool
  default     = false
  description = "Enable it to add karpenter role name to SSM Parameter"
}