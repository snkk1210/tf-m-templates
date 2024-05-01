/** 
# Variables for COMMON
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

variable "sfx" {
  type    = string
  default = "01"
}

/** 
# Variables for EC2
*/
variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "ami" {
  type        = string
  description = "AMI ID to launch"
  default     = "ami-05ffd9ad4ddd0d6e2"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to launch"
  default     = "t3.micro"
}

variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "Whether to grant public IP"
}

variable "root_block_device" {
  type = object({
    volume_type           = string
    volume_size           = number
    delete_on_termination = bool
    encrypted             = bool
  })
  description = "Setting the root volume associated with the instance"

  default = {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = false
  }
}

variable "key_auth_enabled" {
  type    = bool
  default = false
}

variable "bastion_ingress" {
  type    = list(string)
  default = []
}

variable "static_global_ip_enabled" {
  type    = bool
  default = false
}