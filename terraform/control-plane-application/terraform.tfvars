region       = "us-east-1"
namespace    = ""
environment  = ""
user_name    = "" // super admin cognito user name, this user will be entered in admin cognito user pool
tenant_name  = "" // super admin tenant name
tenant_email = "" // email id for super admin 
domain_name  = "abc.com"
from_email   = "no-reply@abc.com" // domain should be verified in SES and SES should be in proudction access to send mail to everyone.