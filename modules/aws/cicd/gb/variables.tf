/**
# COMMON
*/
variable "common" {
  type = object({
    project      = string
    environment  = string
    service_name = string
    region       = string
  })

  default = {
    "project"      = ""
    "environment"  = ""
    "service_name" = ""
    "region"       = ""
  }
}

/**
# CodeBuild
*/
variable "vpc_id" {
  type    = string
  default = ""
}

variable "environment" {
  type = object({
    variables = list(object({
      name  = string
      value = string
      type  = string
    }))
  })
}

variable "codebuild_subnet_ids" {
  type    = list(string)
  default = []
}

variable "privileged_mode" {
  type    = bool
  default = true
}

variable "buildspec" {
  type    = string
  default = "./deploy_scripts/buildspec.yml"
}

variable "image" {
  type    = string
  default = "aws/codebuild/standard:7.0"
}

variable "location" {
  type    = string
  default = ""
}

variable "git_clone_depth" {
  type    = number
  default = 1
}

variable "fetch_submodules" {
  type    = bool
  default = false
}

/** 
# CloudWatch Logs
*/
variable "retention_in_days" {
  type    = number
  default = 400
}