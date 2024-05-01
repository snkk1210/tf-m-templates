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
variable "vpc_cidr" {
  type    = string
  default = ""
}

/** 
# Availability Zone
*/
variable "az1" {
  type    = string
  default = "ap-northeast-1a"
}

variable "az2" {
  type    = string
  default = "ap-northeast-1c"
}

variable "az3" {
  type    = string
  default = "ap-northeast-1d"
}

/** 
# Variables for Subnet ( Public )
*/
variable "public_az1_cidr" {
  type    = string
  default = ""
}

variable "public_az2_cidr" {
  type    = string
  default = ""
}

variable "public_az3_cidr" {
  type    = string
  default = ""
}

/** 
# Variables for Subnet ( Private )
*/
variable "private_az1_cidr" {
  type    = string
  default = ""
}

variable "private_az2_cidr" {
  type    = string
  default = ""
}

variable "private_az3_cidr" {
  type    = string
  default = ""
}

/** 
# Variables for Subnet ( Isolated )
*/
variable "isolated_az1_cidr" {
  type    = string
  default = ""
}

variable "isolated_az2_cidr" {
  type    = string
  default = ""
}

variable "isolated_az3_cidr" {
  type    = string
  default = ""
}
