variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "notify_sns_topic_arn" {
  type    = list(string)
  default = []
}