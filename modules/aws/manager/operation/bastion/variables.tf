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

variable "bastion_log_retention_in_days" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  default = []
}

variable "ami" {
  type        = string
  description = "AMI ID to launch"
  default     = "ami-074cce78125f09d61"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to launch"
  default     = "t3.micro"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to grant public IP"
  default     = false
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

variable "security_group_rules_bastion" {
  type    = list(string)
  default = []
}