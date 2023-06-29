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
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })

  default = {
    cidr_block           = ""
    enable_dns_support   = false
    enable_dns_hostnames = false
  }
}

variable "subnet_cidr_prefix" {
  default = ""
}