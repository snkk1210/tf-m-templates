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

variable "vpc" {
  type = object({
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })

  default = {
    enable_dns_support   = false
    enable_dns_hostnames = false
  }
}

variable "cidr_prefix" {
  default = ""
}