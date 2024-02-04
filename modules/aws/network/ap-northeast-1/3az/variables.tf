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
# Variables for VPC
*/
variable "vpc" {
  type = object({
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })

  default = {
    enable_dns_support   = true
    enable_dns_hostnames = true
  }
}

variable "cidr_prefix" {
  type    = string
  default = "10.0"
}

variable "enable_private" {
  type    = bool
  default = false
}