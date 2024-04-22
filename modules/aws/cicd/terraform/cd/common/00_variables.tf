/**
# Variables for COMMON
*/
variable "common" {
  type = object({
    project      = string
    environment  = string
    service_name = string
    type         = string
  })

  default = {
    "project"      = ""
    "environment"  = ""
    "service_name" = ""
    "type"         = "cd"
  }
}

variable "sfx" {
  type    = string
  default = "01"
}

/** 
# Variables for CodeBuild
*/
variable "plan_buildspec" {
  type    = string
  default = "./deploy_scripts/cd/buildspec-common.yml"
}

variable "apply_buildspec" {
  type    = string
  default = "./deploy_scripts/cd/buildspec-common.yml"
}

variable "plan_environment" {
  type = object({
    compute_type    = string
    image           = string
    privileged_mode = bool
  })

  default = {
    "compute_type"    = "BUILD_GENERAL1_SMALL"
    "image"           = "aws/codebuild/standard:7.0"
    "privileged_mode" = false
  }
}

variable "apply_environment" {
  type = object({
    compute_type    = string
    image           = string
    privileged_mode = bool
  })

  default = {
    "compute_type"    = "BUILD_GENERAL1_SMALL"
    "image"           = "aws/codebuild/standard:7.0"
    "privileged_mode" = false
  }
}

variable "plan_environment_variable" {
  type = object({
    variables = list(object({
      name  = string
      value = string
      type  = string
    }))
  })

  default = {
    variables = []
  }
}

variable "apply_environment_variable" {
  type = object({
    variables = list(object({
      name  = string
      value = string
      type  = string
    }))
  })

  default = {
    variables = []
  }
}

/** 
# Variables for CodePipeline
*/
variable "repository_name" {
  type    = string
  default = ""
}

variable "branch_name" {
  type    = string
  default = "main"
}

variable "target_dir" {
  type    = string
  default = ""
}

variable "artifact_s3_bucket_id" {
  type    = string
  default = ""
}

variable "codestarconnections_connection_arn" {
  type    = string
  default = ""
}