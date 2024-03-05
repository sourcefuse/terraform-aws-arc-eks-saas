locals {
  name        = "aws-observability-accelerator"
  description = "Amazon Managed Grafana workspace for ${local.name}"

  tags = module.tags.tags
}