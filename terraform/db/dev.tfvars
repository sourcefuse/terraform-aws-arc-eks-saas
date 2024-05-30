region = "us-east-1"
environment = "dev"
namespace = "arc-saas"

aurora_db_admin_username              = "arc_saas_root"
aurora_cluster_size                   = 1
aurora_instance_type                  = "db.t3.medium"
aurora_storage_type                   = "aurora-iopt1"
performance_insights_enabled          = true
performance_insights_retention_period = 7
aurora_engine_version                 = "15.4"
aurora_cluster_family                 = "aurora-postgresql15"

