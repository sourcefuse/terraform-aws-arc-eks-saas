<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |
| <a name="module_waf"></a> [waf](#module\_waf) | git::https://github.com/cloudposse/terraform-aws-waf | v1 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_lb.ingress_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_association_resource_arns"></a> [association\_resource\_arns](#input\_association\_resource\_arns) | A list of ARNs of the resources to associate with the web ACL.<br>This must be an ARN of an Application Load Balancer, Amazon API Gateway stage, or AWS AppSync.<br><br>Do not use this variable to associate a Cloudfront Distribution.<br>Instead, you should use the `web_acl_id` property on the `cloudfront_distribution` resource.<br>For more details, refer to https://docs.aws.amazon.com/waf/latest/APIReference/API_AssociateWebACL.html | `list(string)` | `[]` | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | Specifies that AWS WAF should allow requests by default. Possible values: `allow`, `block`. | `string` | `"allow"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | n/a | yes |
| <a name="input_ip_set_reference_statement_rules"></a> [ip\_set\_reference\_statement\_rules](#input\_ip\_set\_reference\_statement\_rules) | A rule statement used to detect web requests coming from particular IP addresses or address ranges.<br><br>  action:<br>    The action that AWS WAF should take on a web request when it matches the rule's statement.<br>  name:<br>    A friendly name of the rule.<br>  priority:<br>    If you define more than one Rule in a WebACL,<br>    AWS WAF evaluates each request against the rules in order based on the value of priority.<br>    AWS WAF processes rules with lower priority first.<br><br>  captcha\_config:<br>   Specifies how AWS WAF should handle CAPTCHA evaluations.<br><br>   immunity\_time\_property:<br>     Defines custom immunity time.<br><br>     immunity\_time:<br>     The amount of time, in seconds, that a CAPTCHA or challenge timestamp is considered valid by AWS WAF. The default setting is 300.<br><br>  rule\_label:<br>     A List of labels to apply to web requests that match the rule match statement<br>  statement:<br>    arn:<br>      The ARN of the IP Set that this statement references.<br>    ip\_set:<br>      Defines a new IP Set<br><br>      description:<br>        A friendly description of the IP Set<br>      addresses:<br>        Contains an array of strings that specifies zero or more IP addresses or blocks of IP addresses.<br>        All addresses must be specified using Classless Inter-Domain Routing (CIDR) notation.<br>      ip\_address\_version:<br>        Specify `IPV4` or `IPV6`<br>    ip\_set\_forwarded\_ip\_config:<br>      fallback\_behavior:<br>        The match status to assign to the web request if the request doesn't have a valid IP address in the specified position.<br>        Possible values: `MATCH`, `NO_MATCH`<br>      header\_name:<br>        The name of the HTTP header to use for the IP address.<br>      position:<br>        The position in the header to search for the IP address.<br>        Possible values include: `FIRST`, `LAST`, or `ANY`.<br>  visibility\_config:<br>    Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>    cloudwatch\_metrics\_enabled:<br>      Whether the associated resource sends metrics to CloudWatch.<br>    metric\_name:<br>      A friendly name of the CloudWatch metric.<br>    sampled\_requests\_enabled:<br>      Whether AWS WAF should store a sampling of the web requests that match the rules. | <pre>list(object({<br>    name     = string<br>    priority = number<br>    action   = string<br>    captcha_config = optional(object({<br>      immunity_time_property = object({<br>        immunity_time = number<br>      })<br>    }), null)<br>    rule_label = optional(list(string), null)<br>    statement  = any<br>    visibility_config = optional(object({<br>      cloudwatch_metrics_enabled = optional(bool)<br>      metric_name                = string<br>      sampled_requests_enabled   = optional(bool)<br>    }), null)<br>  }))</pre> | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. arc | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->