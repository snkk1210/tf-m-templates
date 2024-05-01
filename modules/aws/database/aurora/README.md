# database/aurora

### What is this ?

Create an RDS Aurora Cluster.

### How to use ?

#### PostgreSQL

```
module "database_aurora" {
  source = "git::https://github.com/snkk1210/tf-m-templates.git//modules/aws/database/aurora"

  common = {
    project      = "snkk1210"
    environment  = "sandbox"
    service_name = "postgresql"
  }

  vpc_id = "< VPC ID >"
  subnet_ids = [
    "< Subnet A ID >",
    "< Subnet B ID >"
  ]

  rds_cluster_parameter_group = {
    family    = "aurora-postgresql14"
    parameter = {}
  }

  db_parameter_group = {
    family    = "aurora-postgresql14"
    parameter = {}
  }

  rds_cluster = {
    master_username              = "root"
    master_password              = "hogehoge"
    backup_retention_period      = 30
    engine                       = "aurora-postgresql"
    engine_version               = "14.9"
    port                         = 5432
    preferred_backup_window      = "17:00-18:00"
    preferred_maintenance_window = "mon:18:00-mon:19:00"
    apply_immediately            = true
    deletion_protection          = false
    skip_final_snapshot          = false
    storage_encrypted            = true
  }

  rds_cluster_instance = {
    count                      = 1
    instance_class             = "db.t3.medium"
    engine                     = "aurora-postgresql"
    engine_version             = "14.9"
    apply_immediately          = true
    auto_minor_version_upgrade = false
    publicly_accessible        = false
    storage_type               = "gp2"
  }

  performance_insights_enabled    = false
  enabled_cloudwatch_logs_exports = ["postgresql"]
  ingress_cidr_blocks = [
    "xxx.xxx.xxx.xxx/xx",
    "xxx.xxx.xxx.xxx/xx"
  ]
}
```

#### MySQL

```
module "database_aurora" {
  source = "git::https://github.com/snkk1210/tf-m-templates.git//modules/aws/database/aurora"

  common = {
    project      = "snkk1210"
    environment  = "sandbox"
    service_name = "mysql"
  }

  vpc_id = "< VPC ID >"
  subnet_ids = [
    "< Subnet A ID >",
    "< Subnet B ID >"
  ]

  rds_cluster_parameter_group = {
    family    = "aurora-mysql8.0"
    parameter = {}
  }

  db_parameter_group = {
    family    = "aurora-mysql8.0"
    parameter = {}
  }

  rds_cluster = {
    master_username              = "root"
    master_password              = "hogehoge"
    backup_retention_period      = 30
    engine                       = "aurora-mysql"
    engine_version               = "8.0.mysql_aurora.3.06.0"
    port                         = 5432
    preferred_backup_window      = "17:00-18:00"
    preferred_maintenance_window = "mon:18:00-mon:19:00"
    apply_immediately            = true
    deletion_protection          = false
    skip_final_snapshot          = false
    storage_encrypted            = true
  }

  rds_cluster_instance = {
    count                      = 1
    instance_class             = "db.t3.medium"
    engine                     = "aurora-mysql"
    engine_version             = "8.0.mysql_aurora.3.06.0"
    apply_immediately          = true
    auto_minor_version_upgrade = false
    publicly_accessible        = false
    storage_type               = "gp2"
  }

  performance_insights_enabled    = false
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  ingress_cidr_blocks = [
    "xxx.xxx.xxx.xxx/xx",
    "xxx.xxx.xxx.xxx/xx"
  ]
}
```