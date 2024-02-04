/** 
# Variables for COMMON
*/
variable "common" {
  type = object({
    project     = string
    environment = string
    region      = string
  })

  default = {
    project     = ""
    environment = ""
    region      = ""
  }
}

variable "sfx" {
  type    = string
  default = "01"
}

/** 
# Variables for Lambda
*/
variable "kms_encrypted_hookurl" {
  type = string
}

variable "channel_name" {
  type = string
}

variable "reserved_concurrent_executions" {
  type    = number
  default = -1
}

/** 
# Variables for KMS
*/
variable "enable_kms" {
  type    = bool
  default = false
}