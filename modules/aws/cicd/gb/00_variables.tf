/**
# COMMON
*/
variable "common" {
  type = object({
    project      = string
    environment  = string
    service_name = string
  })

  default = {
    "project"      = ""
    "environment"  = ""
    "service_name" = ""
  }
}

variable "sfx" {
  type    = string
  default = "01"
}

/**
# CodeBuild
*/
variable "environment" {
  type = object({
    variables = list(object({
      name  = string
      value = string
      type  = string
    }))
  })
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

variable "compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"
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

variable "filter_groups" {
  type = list(object({
    pattern = string
    type    = string
  }))

  default = [
    {
      pattern = "PULL_REQUEST_CREATED"
      type    = "EVENT"
    },
    {
      pattern = "PULL_REQUEST_UPDATED"
      type    = "EVENT"
    },
    {
      pattern = "PULL_REQUEST_REOPENED"
      type    = "EVENT"
    }
  ]
}

/** 
# CloudWatch Logs
*/
variable "retention_in_days" {
  type    = number
  default = 400
}