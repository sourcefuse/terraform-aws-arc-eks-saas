##############################################################################
##Tags
##############################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

##############################################################################
##WAF
##############################################################################

module "waf" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-waf?ref=v1"
  enabled                   = var.enabled
  name                      = "${var.namespace}-${var.environment}-waf"
  association_resource_arns = concat(local.load_balancer_arn, var.association_resource_arns)
  default_action            = var.default_action
  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "rules-example-metric"
    sampled_requests_enabled   = true
  }

  # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
  managed_rule_group_statement_rules = [
    {
      name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      priority = 1

      statement = {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      }
    },
    {
      name     = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority = 2

      statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      }
    },
    {
      name     = "AWS-AWSManagedRulesCommonRuleSet"
      priority = 3

      statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }

      rule_action_override = {
        NoUserAgent_HEADER = {
          action = "allow"
        }
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      }
    },
    {
      name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority = 4

      statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      }
    },
    # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-bot.html
    # {
    #   name     = "AWS-AWSManagedRulesBotControlRuleSet"
    #   priority = 5

    #   statement = {
    #     name        = "AWSManagedRulesBotControlRuleSet"
    #     vendor_name = "AWS"

    #     rule_action_override = {
    #       CategoryHttpLibrary = {
    #         action = "block"
    #         custom_response = {
    #           response_code = "404"
    #           response_header = {
    #             name  = "example-1"
    #             value = "example-1"
    #           }
    #         }
    #       }
    #       SignalNonBrowserUserAgent = {
    #         action = "count"
    #         custom_request_handling = {
    #           insert_header = {
    #             name  = "example-2"
    #             value = "example-2"
    #           }
    #         }
    #       }
    #     }

    #     managed_rule_group_configs = [
    #       {
    #         aws_managed_rules_bot_control_rule_set = {
    #           inspection_level = "COMMON"
    #         }
    #       }
    #     ]
    #   }

    #   visibility_config = {
    #     cloudwatch_metrics_enabled = true
    #     sampled_requests_enabled   = true
    #     metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
    #   }
    # }
  ]


  # rate_based_statement_rules = [
  #   {
  #     name     = "rule-40"
  #     action   = "allow"
  #     priority = 40

  #     statement = {
  #       limit              = 100
  #       aggregate_key_type = "IP"
  #     }

  #     visibility_config = {
  #       cloudwatch_metrics_enabled = false
  #       sampled_requests_enabled   = false
  #       metric_name                = "rule-40-metric"
  #     }
  #   }
  # ]


  sqli_match_statement_rules = [
    {
      name     = "rule-70"
      action   = "block"
      priority = 70

      statement = {

        field_to_match = {
          query_string = {}
        }

        text_transformation = [
          {
            type     = "URL_DECODE"
            priority = 1
          },
          {
            type     = "HTML_ENTITY_DECODE"
            priority = 2
          }
        ]

      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
        metric_name                = "rule-70-metric"
      }
    }
  ]

  geo_match_statement_rules = [
    {
      name     = "rule-80"
      action   = "count"
      priority = 80

      statement = {
        country_codes = ["US", "GB", "IN"]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "rule-80-metric"
      }
    },
    {
      name     = "rule-11"
      action   = "allow"
      priority = 60

      statement = {
        country_codes = ["US", "IN"]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
        metric_name                = "rule-11-metric"
      }
    }
  ]

  geo_allowlist_statement_rules = [
    {
      name     = "rule-90"
      priority = 90
      action   = "count"

      statement = {
        country_codes = ["US", "IN"]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
        metric_name                = "rule-90-metric"
      }
    },
    {
      name     = "rule-95"
      priority = 95
      action   = "block"

      statement = {
        country_codes = ["DE"]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
        metric_name                = "rule-95-metric"
      }
    }
  ]

  # regex_match_statement_rules = [
  #   {
  #     name     = "rule-100"
  #     priority = 100
  #     action   = "block"

  #     statement = {
  #       regex_string = "^/admin"

  #       text_transformation = [
  #         {
  #           priority = 90
  #           type     = "COMPRESS_WHITE_SPACE"
  #         }
  #       ]

  #       field_to_match = {
  #         uri_path = {}
  #       }
  #     }

  #     visibility_config = {
  #       cloudwatch_metrics_enabled = false
  #       sampled_requests_enabled   = false
  #       metric_name                = "rule-100-metric"
  #     }
  #   }
  # ]

  # ip_set_reference_statement_rules = [
  #   {
  #     name     = "rule-110"
  #     priority = 110
  #     action   = "block"

  #     statement = {
  #       ip_set = {
  #         ip_address_version = "IPV4"
  #         addresses          = ["157.38.120.154/32"]
  #       }
  #     }

  #     visibility_config = {
  #       cloudwatch_metrics_enabled = false
  #       sampled_requests_enabled   = false
  #       metric_name                = "rule-110-metric"
  #     }
  #   }
  # ]



  tags = module.tags.tags
}