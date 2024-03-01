########################################################################
## data lookup
########################################################################
data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.eks_cluster_name
}

# Get aws-auth config map data source
data "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

########################################################################
## provider
########################################################################
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

########################################################################
## Update aws-auth configmap
########################################################################
resource "kubernetes_config_map_v1_data" "aws_auth" {
  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    # Convert to list, make distinct to remove duplicates, and convert to YAML as mapRoles is a YAML string.
    # Replace() removes double quotes on "strings" in YAML output.
    # Distinct() only applies the change once, not append every run.
    mapRoles = replace(yamlencode(distinct(concat(yamldecode(data.kubernetes_config_map.aws_auth.data.mapRoles), yamldecode(local.new_role_yaml)))), "\"", "")
    #mapUsers    = replace(yamlencode(distinct(concat(yamldecode(data.kubernetes_config_map.aws_auth.data.mapUsers), yamldecode(local.new_user_yaml)))), "\"", "")
    mapAccounts = length(local.new_account_yaml) > 0 ? replace(yamlencode(distinct(concat(yamldecode(coalesce(data.kubernetes_config_map.aws_auth.data.mapAccounts, "[]")), yamldecode(local.new_account_yaml)))), "\"", "") : ""
    mapUsers    = length(local.new_user_yaml) > 0 ? replace(yamlencode(distinct(concat(yamldecode(coalesce(data.kubernetes_config_map.aws_auth.data.mapUsers, "[]")), yamldecode(local.new_user_yaml)))), "\"", "") : ""

  }

  lifecycle {
    ignore_changes  = []
    prevent_destroy = true
  }
}