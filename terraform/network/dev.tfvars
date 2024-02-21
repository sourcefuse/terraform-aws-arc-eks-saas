environment                    = "dev"
region                         = "us-east-1"
namespace                      = "arc-saas"
vpc_ipv4_primary_cidr_block    = "10.0.0.0/16"
client_vpn_enabled             = false
client_vpn_authorization_rules = []


# specify availibility zones for default subnets 
availability_zones = ["us-west-1a", "us-west-1b"]

# If is_custom_subnet_enabled variable is true then define these variables
is_custom_subnet_enabled  = false
private_subnet_count      = 2
public_subnet_count       = 2
custom_private_subnet_ids = []
custom_public_subnet_ids  = []
