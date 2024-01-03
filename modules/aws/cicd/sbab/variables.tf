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
variable "environment" {
  type = object({
    privileged_mode = bool
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

variable "stage1_buildspec" {
  type    = string
  default = "./deploy_scripts/buildspec.yml"
}

variable "stage2_buildspec" {
  type    = string
  default = "./deploy_scripts/buildspec.yml"

}

variable "stage1_image" {
  type = string
  default = "aws/codebuild/standard:7.0"
}

variable "stage2_image" {
  type = string
  default = "aws/codebuild/standard:7.0"
}

/**
# CodePipeline
*/
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