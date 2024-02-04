variable "notify_sns_topic_arn" {
  type    = list(string)
  default = []
}

variable "natgw_instance_alarm" {
  type = list(object({
    natgw_instance_name = string
    natgw_instance_id   = string

    // NATGW ErrorPortAllocation
    natgw_errorportallocation_evaluation_periods = string
    natgw_errorportallocation_period             = string
    natgw_errorportallocation_statistic          = string
    natgw_errorportallocation_threshold          = string

  }))
}