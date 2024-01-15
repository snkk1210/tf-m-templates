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

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "aurora_cluster_parameter_group" {
  type = object({
    family    = string
    parameter = map(string)
  })
  default = {
    family    = ""
    parameter = {}
  }
}

variable "aurora_db_parameter_group" {
  type = object({
    family    = string
    parameter = map(string)
  })
  default = {
    family    = ""
    parameter = {}
  }
}

variable "aurora_cluster" {
  type = object({
    master_username              = string
    master_password              = string
    backup_retention_period      = number
    engine                       = string
    engine_version               = string
    preferred_backup_window      = string
    preferred_maintenance_window = string
    apply_immediately            = bool
    storage_encrypted            = bool
    deletion_protection          = bool
    skip_final_snapshot          = bool
  })

  default = {
    master_username              = ""
    master_password              = ""
    backup_retention_period      = 14
    engine                       = ""
    engine_version               = ""
    preferred_backup_window      = ""
    preferred_maintenance_window = ""
    apply_immediately            = false
    storage_encrypted            = true
    deletion_protection          = false
    skip_final_snapshot          = true
  }
}


variable "aurora_cluster_instance" {
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
    instance_class             = ""
    engine                     = ""
    engine_version             = ""
    storage_type               = ""
    publicly_accessible        = false
    auto_minor_version_upgrade = false
    apply_immediately          = false
  }
}

variable "cloudwatch_log_retention_in_days" {
  type    = number
  default = 90
}

variable "performance_insights_enabled" {
  type    = bool
  default = false
}

variable "aurora_ingress" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}