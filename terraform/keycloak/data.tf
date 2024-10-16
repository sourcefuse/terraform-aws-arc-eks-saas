data "aws_ssm_parameter" "db_host" {
  name = "/${var.namespace}/${var.environment}/db_host"
}

data "aws_ssm_parameter" "db_user" {
  name = "/${var.namespace}/${var.environment}/db_user"
}

data "aws_ssm_parameter" "db_password" {
  name = "/${var.namespace}/${var.environment}/db_password"
}

data "aws_ssm_parameter" "db_port" {
  name = "/${var.namespace}/${var.environment}/db_port"
}

data "aws_ssm_parameter" "keycloak_db_name" {
  name = "/${var.namespace}/${var.environment}/keycloakdbdatabase"
}


data "aws_eks_cluster" "cluster" {
  name = "${var.namespace}-${var.environment}-eks-cluster"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "${var.namespace}-${var.environment}-eks-cluster"
}
