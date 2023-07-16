/**
# COMMON
*/
variable "common" {
  type = object({
    project     = string
    environment = string
  })

  default = {
    "project"     = ""
    "environment" = ""
  }
}

/** 
# APIGateway
*/
variable "redeployment_version" {
  default = "0.0.1"
}

variable "stage_name" {
  default = "dev"
}

/** 
# Lambda
*/
variable "reserved_concurrent_executions" {
  type    = number
  default = -1
}
