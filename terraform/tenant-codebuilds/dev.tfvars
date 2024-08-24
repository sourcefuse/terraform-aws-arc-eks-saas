region                     = "us-west-2"
namespace                  = "sf-arc-saas"
environment                = "dev"
concurrent_build_limit     = 10
is_organization            = true
organization_name          = "sourcefuse"
premium_source_version     = "refs/heads/main"
standard_source_version    = "refs/heads/main"
basic_source_version       = "refs/heads/main"
premium_buildspec          = "tenant-templates/silo/buildspec.yaml"
standard_buildspec         = "tenant-templates/bridge/buildspec.yaml"
basic_buildspec            = "tenant-templates/pooled/buildspec.yaml"
premium_offboard_buildspec = "tenant-templates/silo/offboard-buildspec.yaml"

domain_name        = "arc-saas.net"
control_plane_host = "https://arc-saas.net"