locals {
  private_cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block]
  private_subnet_ids  = [for s in data.aws_subnet.private : s.id]
  private_subnet_azs  = [for s in data.aws_subnet.private : s.availability_zone]

  public_cidr_blocks = [for s in data.aws_subnet.public : s.cidr_block]
  public_subnet_ids  = [for s in data.aws_subnet.public : s.id]


  ### ingress Security Group Rules ########
  additional_sg_rules = concat(var.additional_sg_rules, [
    {
      name        = "os-http-security-group"
      description = "HTTP inbound ingress"
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = concat(local.private_cidr_blocks, local.public_cidr_blocks)
    },
    {
      name        = "os-https-security-group"
      description = "HTTPS inbound ingress"
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      cidr_blocks = concat(local.private_cidr_blocks, local.public_cidr_blocks)
    }
  ])
}