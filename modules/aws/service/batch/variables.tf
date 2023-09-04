/**
# Variables For Batch
*/
variable "common" {
  type = object({
    project      = string
    environment  = string
    service_name = string
    region       = string
  })

  default = {
    project      = ""
    environment  = ""
    service_name = ""
    region       = ""
  }
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "batch_subnet_ids" {
  type    = list(string)
  default = []
}

variable "batch_definition" {
  type = object({
    vcpu   = number
    memory = number
  })
  default = {
    vcpu   = 256
    memory = 512
  }
}

variable "batch_cron" {
  type    = string
  default = ""
}

variable "ecr_repository_batch" {
  type = object({
    image_tag_mutability          = string
    scan_on_push                  = bool
    lifecycle_policy_count_number = number
  })

  default = {
    image_tag_mutability          = "MUTABLE"
    scan_on_push                  = false
    lifecycle_policy_count_number = 15
  }
}

variable "log_retention_in_days" {
  type    = number
  default = 30
}

variable "max_vcpus" {
  type    = number
  default = 512
}

variable "timeout_sec" {
  type    = number
  default = 3600
}

variable "command" {
  type    = string
  default = ""
}