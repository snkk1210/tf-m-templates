variable "common" {
  type = object({
    project      = string
    environment  = string
    service_name = string
  })

  default = {
    "project"     = ""
    "environment" = ""
    service_name  = ""
  }
}

variable "aws_eks_cluster_version" {
  type = string
  default = ""
}

variable "eks_subnet_ids" {
  type    = list(string)
  default = []
}

variable "eks_node_subnet_ids" {
  type    = list(string)
  default = []
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}