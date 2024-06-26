/** 
# Variables for COMMON
*/
variable "common" {
  type = object({
    project      = string
    environment  = string
    service_name = string
  })

  default = {
    project      = ""
    environment  = ""
    service_name = ""
  }
}

variable "sfx" {
  type    = string
  default = "01"
}

/** 
# Variables for RDS ( Aurora )
*/
variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "rds_cluster_parameter_group" {
  type = object({
    family    = string
    parameter = map(string)
  })
  default = {
    family    = ""
    parameter = {}
  }
}

variable "db_parameter_group" {
  type = object({
    family    = string
    parameter = map(string)
  })
  default = {
    family    = ""
    parameter = {}
  }
}

variable "rds_cluster" {
  type = object({
    master_username              = string
    master_password              = string
    engine                       = string
    engine_version               = string
    port                         = number
    preferred_backup_window      = string
    preferred_maintenance_window = string
    apply_immediately            = bool
    storage_encrypted            = bool
    backup_retention_period      = number
    deletion_protection          = bool
    skip_final_snapshot          = bool
  })

  default = {
    master_username              = "root"
    master_password              = "hogehoge"
    engine                       = "aurora-postgresql"
    engine_version               = "14.9"
    port                         = 5432
    preferred_backup_window      = "17:00-18:00"
    preferred_maintenance_window = "mon:18:00-mon:19:00"
    apply_immediately            = false
    storage_encrypted            = true
    backup_retention_period      = 14
    deletion_protection          = false
    skip_final_snapshot          = true
  }
}


variable "rds_cluster_instance" {
  type = object({
    count                      = number
    instance_class             = string
    engine                     = string
    engine_version             = string
    storage_type               = string
    publicly_accessible        = bool
    auto_minor_version_upgrade = bool
    apply_immediately          = bool
  })

  default = {
    count                      = 0
    instance_class             = "db.t3.medium"
    engine                     = "aurora-postgresql"
    engine_version             = "14.9"
    storage_type               = "gp2"
    publicly_accessible        = false
    auto_minor_version_upgrade = false
    apply_immediately          = false
  }
}

variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = ["audit", "error", "general", "slowquery"]
  //default = ["postgresql"]
}

variable "performance_insights_enabled" {
  type    = bool
  default = false
}

variable "ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}