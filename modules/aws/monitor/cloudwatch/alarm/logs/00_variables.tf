/** 
# Variables for COMMON
*/
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

/** 
# Variables for CloudWatch
*/
variable "action" {
  type = object({
    alarm        = list(string)
    ok           = list(string)
    insufficient = list(string)
  })

  default = {
    alarm        = []
    ok           = []
    insufficient = []
  }
}

variable "log_metric_filters" {
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