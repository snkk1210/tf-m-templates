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

variable "vpc_id" {
  type    = string
  default = ""
}

variable "codebuild_subnet_ids" {
  type    = list(string)
  default = []
}

/**
# CodePipeline
*/
variable "artifact_bucket" {
  type    = string
  default = ""
}

variable "reference_name" {
  type    = string
  default = ""
}

/**
# EventBridge
*/
variable "enable_auto_deploy" {
  type    = bool
  default = false
}