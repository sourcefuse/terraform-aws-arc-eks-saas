region                     = "us-west-2"
namespace                  = "sf-arc-saas"
environment                = "dev"
concurrent_build_limit     = 10
premium_source_version     = "refs/heads/main"
standard_source_version    = "refs/heads/main"
basic_source_version       = "refs/heads/main"
premium_buildspec          = "buildspec.yaml"
standard_buildspec         = "buildspec.yaml"
basic_buildspec            = "buildspec.yaml"
premium_offboard_buildspec = "offboard-buildspec.yaml"

domain_name        = "arc-saas.net"
control_plane_host = "https://arc-saas.net"