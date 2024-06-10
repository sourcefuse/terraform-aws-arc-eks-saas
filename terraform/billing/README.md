<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.4.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket_suffix"></a> [bucket\_suffix](#module\_bucket\_suffix) | ../../modules/random-password | n/a |
| <a name="module_budgets"></a> [budgets](#module\_budgets) | sourcefuse/arc-billing/aws | 0.0.1 |
| <a name="module_cur"></a> [cur](#module\_cur) | ../../modules/cost-usage-report | n/a |
| <a name="module_kubecost_iam_role"></a> [kubecost\_iam\_role](#module\_kubecost\_iam\_role) | ../../modules/iam-role | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy_attachment.kubecost_role_attachment1](https://registry.terraform.io/providers/aws/5.4.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kubecost_role_attachment2](https://registry.terraform.io/providers/aws/5.4.0/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.kubecost](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.kubecost_ingress](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [kubernetes_annotations.service_account](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/annotations) | resource |
| [local_file.helm_values](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster_auth](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.kubecost_sa_policy](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.prometheus_workspace_id](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/ssm_parameter) | data source |
| [template_file.ingress_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.kubecost_helm_value_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_alerts_sns_subscribers"></a> [billing\_alerts\_sns\_subscribers](#input\_billing\_alerts\_sns\_subscribers) | A map of subscription configurations for SNS topics<br><br>For more information, see:<br>https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference<br><br>protocol:<br>  The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially<br>  supported, see link) (email is an option but is unsupported in terraform, see link).<br>endpoint:<br>  The endpoint to send data to, the contents will vary with the protocol. (see link for more information)<br>endpoint\_auto\_confirms:<br>  Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is<br>  false<br>raw\_message\_delivery:<br>  Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property).<br>  Default is false | <pre>map(object({<br>    protocol               = string<br>    endpoint               = string<br>    endpoint_auto_confirms = bool<br>    raw_message_delivery   = bool<br>  }))</pre> | `null` | no |
| <a name="input_budgets"></a> [budgets](#input\_budgets) | A list of Budgets to create. | `any` | `[]` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name for the SAAS Application | `string` | n/a | yes |
| <a name="input_encryption_enabled"></a> [encryption\_enabled](#input\_encryption\_enabled) | Whether or not to use encryption. If set to `true` and no custom value for KMS key (kms\_master\_key\_id) is provided, a KMS key is created. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_notifications_enabled"></a> [notifications\_enabled](#input\_notifications\_enabled) | Whether or not to setup Slack notifications. Set to `true` to create an SNS topic and Lambda function to send alerts to Slack. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | The name of the channel in Slack for notifications. Only used when `notifications_enabled` is `true` | `string` | `""` | no |
| <a name="input_slack_username"></a> [slack\_username](#input\_slack\_username) | The username that will appear on Slack messages. Only used when `notifications_enabled` is `true` | `string` | `""` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | The URL of Slack webhook. Only used when `notifications_enabled` is `true` | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->