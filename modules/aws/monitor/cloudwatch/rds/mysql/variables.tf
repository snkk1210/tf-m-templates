variable "notify_sns_topic_arn" {
  type    = list(string)
  default = []
}

variable "rds_alarm" {
  type = list(object({
    rds_name = string

    // CPUUtilization
    rds_cpuutilization_evaluation_periods = string
    rds_cpuutilization_period             = string
    rds_cpuutilization_statistic          = string
    rds_cpuutilization_threshold          = string

    // FreeableMemory
    rds_freeablememory_evaluation_periods = string
    rds_freeablememory_period             = string
    rds_freeablememory_statistic          = string
    rds_freeablememory_threshold          = string

    // Cluster DMLLatency
    rds_freestoragespace_evaluation_periods = string
    rds_freestoragespace_period             = string
    rds_freestoragespace_statistic          = string
    rds_freestoragespace_threshold          = string

  }))
}
