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