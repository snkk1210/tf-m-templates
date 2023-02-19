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