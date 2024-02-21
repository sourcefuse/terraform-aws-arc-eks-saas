################################################################################
## bastion
################################################################################
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_name" {
  description = "Name of VPC"
  value       = "${var.namespace}-${var.environment}-vpc"
}


output "private_subnet_names" {
  description = "Private subnet Names"
  value = [for idx in range(max(var.private_subnet_count, length(var.availability_zones))) :
    "${var.namespace}-${var.environment}-private-subnet-private-${var.region}${element(["a", "b", "c", "d", "e"], idx)}"
  ]
}

output "public_subnet_names" {
  description = "Public subnet Names"
  value = [for idx in range(max(var.public_subnet_count, length(var.availability_zones))) :
    "${var.namespace}-${var.environment}-public-subnet-public-${var.region}${element(["a", "b", "c", "d", "e"], idx)}"
  ]
}

output "vpc_cidr" {
  description = "The VPC CIDR block"
  value       = var.vpc_ipv4_primary_cidr_block
}

output "vpn_endpoint_dns_name" {
  value       = module.network.vpn_endpoint_dns_name
  description = "The DNS Name of the Client VPN Endpoint Connection."
}

