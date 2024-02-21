# Reference Architecture DevOps Infrastructure: Database  

## Overview

AWS RDS/Aurora for the SourceFuse DevOps Reference Architecture Infrastructure.  

## Usage
1. Initialize the backend:
  ```shell
  terraform init -backend-config=backend/config.dev.hcl
  ```
2. Plan Terraform
  ```shell
  terraform plan -var-file .\tfvars\dev.tfvars
  ```
3. Apply Terraform
  ```shell
  terraform apply -var-file .\tfvars\dev.tfvars
  ```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |
| <a name="provider_aws.network"></a> [aws.network](#provider\_aws.network) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | sourcefuse/arc-db/aws | 2.0.4 |
| <a name="module_terraform-aws-arc-tags"></a> [terraform-aws-arc-tags](#module\_terraform-aws-arc-tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group_rule.additional_inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_security_groups.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.network_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_inbound_rules"></a> [additional\_inbound\_rules](#input\_additional\_inbound\_rules) | n/a | <pre>list(object({<br>    description = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    #cidr_blocks       = list(string)<br>    security_group_id = optional(list(string))<br>    ipv6_cidr_blocks  = optional(list(string))<br><br>  }))</pre> | n/a | yes |
| <a name="input_aurora_cluster_data"></a> [aurora\_cluster\_data](#input\_aurora\_cluster\_data) | RDS cluster data | <pre>list(object({<br>    aurora_cluster_name                   = string,<br>    aurora_db_admin_username              = string,<br>    aurora_db_name                        = string,<br>    aurora_allow_major_version_upgrade    = bool,<br>    aurora_auto_minor_version_upgrade     = bool,<br>    aurora_cluster_size                   = number,<br>    aurora_instance_type                  = string,<br>    aurora_engine                         = string,<br>    aurora_engine_version                 = string,<br>    performance_insights_enabled          = bool,<br>    performance_insights_retention_period = number,<br>    aurora_storage_type                   = string,<br>    iam_database_authentication_enabled   = bool<br>  }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `"dev"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_arns"></a> [aurora\_arns](#output\_aurora\_arns) | Amazon Resource Name (ARN) of cluster |
| <a name="output_aurora_endpoints"></a> [aurora\_endpoints](#output\_aurora\_endpoints) | The DNS address of the Aurora instance |
| <a name="output_aurora_reader_endpoint"></a> [aurora\_reader\_endpoint](#output\_aurora\_reader\_endpoint) | A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->