environment = "dev"
region = "us-west-2"
namespace = "sf-arc-saas"
vpc_ipv4_primary_cidr_block    = "10.0.0.0/16"
client_vpn_enabled             = false
client_vpn_authorization_rules = []


# specify availibility zones for default subnets 
availability_zones = ["us-west-2a", "us-west-2b"]

# If is_custom_subnet_enabled variable is true then define these variables
is_custom_subnet_enabled  = false
private_subnet_count      = 0
public_subnet_count       = 0
custom_private_subnet_ids = []
custom_public_subnet_ids  = []
