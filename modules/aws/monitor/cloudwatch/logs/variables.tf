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

variable "notify_sns_topic_arn" {
  type    = list(string)
  default = []
}

variable "log_group_error_filter" {
  type = list(object({
    log_group_name  = string
    log_filter_name = string
    pattern         = string

    log_detection_evaluation_periods = string
    log_detection_period             = string
    log_detection_statistic          = string
    log_detection_threshold          = string
  }))
}