region      = "us-east-1"
environment = "dev"
namespace   = "arc-saas"
domain_name = "arc-saas.net"

budgets = [
    {
    name         = "total-monthly-budget"
    budget_type  = "COST"
    limit_amount = "300"
    limit_unit   = "USD"
    time_unit    = "MONTHLY"

    notification = {
      comparison_operator        = "GREATER_THAN"
      threshold                  = "100"
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = ["example@example-email.com"]
    }
  }
]

notifications_enabled = true

billing_alerts_sns_subscribers = {
  "email" = {
      protocol               = "email"
      endpoint               = "harshit.kumar@sourcefuse.com"
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
}