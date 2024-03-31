/** 
# Variables for COMMON
*/
variable "common" {
  type = object({
    project     = string
    environment = string
  })

  default = {
    project     = ""
    environment = ""
  }
}

variable "sfx" {
  type    = string
  default = "01"
}

/** 
# Variables for Lambda
*/
variable "env_var" {
  type = object({
    channel_name    = string
    hook_url        = string
    notification_to = string
  })

  default = {
    channel_name    = ""
    hook_url        = ""
    notification_to = "!channel"
  }
}

variable "reserved_concurrent_executions" {
  type    = number
  default = -1
}

variable "lambda_runtime" {
  type    = string
  default = "python3.12"
}

/** 
# Variables for KMS
*/
variable "enable_kms" {
  type    = bool
  default = false
}