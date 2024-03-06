
output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = module.eks_cluster.eks_cluster_id
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_identity_oidc_issuer" {
  description = "The OIDC Identity issuer for the cluster"
  value       = module.eks_cluster.eks_cluster_identity_oidc_issuer
}

output "eks_oidc_issuer_arn" {
  description = "EKS Cluster OIDC issuer"
  value       = module.eks_cluster.eks_oidc_issuer_arn
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the cluster"
  value       = module.eks_cluster.eks_cluster_version
}

output "karpenter_role_name" {
  description = "EKS Karpenter Role Name"
  value       = module.eks_blueprints_addons.karpenter.node_iam_role_name
}

output "fluentbit_role_arn" {
  description = "EKS Karpenter Role Name"
  value       = module.eks_blueprints_addons.aws_for_fluentbit.iam_role_arn
}