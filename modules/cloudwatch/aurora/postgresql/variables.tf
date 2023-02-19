variable "common" {
  type = object({
    project     = string
    environment = string
  })

  default = {
    environment = ""
    project     = ""
  }
}

variable "cloudwatch_alarm_notify_sns_topic_arn" {
  type = string
}

variable "aurora_cluster_alarm" {
  type = list(object({
    aurora_cluster_name = string

    // Cluster Writer CPUUtilization
    aurora_writer_cpuutilization_evaluation_periods = string
    aurora_writer_cpuutilization_period             = string
    aurora_writer_cpuutilization_statistic          = string
    aurora_writer_cpuutilization_threshold          = string

    // Cluster Reader CPUUtilization
    aurora_reader_cpuutilization_evaluation_periods = string
    aurora_reader_cpuutilization_period             = string
    aurora_reader_cpuutilization_statistic          = string
    aurora_reader_cpuutilization_threshold          = string

    // Cluster Writer FreeableMemory
    aurora_writer_freeablememory_evaluation_periods = string
    aurora_writer_freeablememory_period             = string
    aurora_writer_freeablememory_statistic          = string
    aurora_writer_freeablememory_threshold          = string

    // Cluster Reader FreeableMemory
    aurora_reader_freeablememory_evaluation_periods = string
    aurora_reader_freeablememory_period             = string
    aurora_reader_freeablememory_statistic          = string
    aurora_reader_freeablememory_threshold          = string

  }))
}

variable "aurora_instance_alarm" {
  type = list(object({
    aurora_instance_name = string

    // Instance DatabaseConnections
    aurora_databaseconnections_evaluation_periods = string
    aurora_databaseconnections_period             = string
    aurora_databaseconnections_statistic          = string
    aurora_databaseconnections_threshold          = string

    // Cluster FreeLocalStorage
    aurora_freelocalstorage_evaluation_periods = string
    aurora_freelocalstorage_period             = string
    aurora_freelocalstorage_statistic          = string
    aurora_freelocalstorage_threshold          = string

  }))
}