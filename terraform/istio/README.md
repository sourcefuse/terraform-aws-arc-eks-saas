<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_istio"></a> [istio](#module\_istio) | ../../modules/istio | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.istio_gateway](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.k8s_ingress](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.apply_manifests](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | AWS CertificateMmanager Certificate ARN for the AWS LoadBalancer. | `string` | n/a | yes |
| <a name="input_alb_ingress_name"></a> [alb\_ingress\_name](#input\_alb\_ingress\_name) | The ALB Ingress name by which the load balancer will be created. | `string` | `""` | no |
| <a name="input_common_name"></a> [common\_name](#input\_common\_name) | Domain Name  supplied as commn name. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_full_domain_name"></a> [full\_domain\_name](#input\_full\_domain\_name) | Domain  with wildcard   example >>   *.domain.in | `string` | n/a | yes |
| <a name="input_max_pods"></a> [max\_pods](#input\_max\_pods) | The maximum number of pods to scale up for the Istio ingress gateway. This limits the resources used and manages the scaling behavior. | `number` | n/a | yes |
| <a name="input_min_pods"></a> [min\_pods](#input\_min\_pods) | The minimum number of pods to maintain for the Istio ingress gateway. This ensures basic availability and load handling. | `number` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization name supplied as common name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->