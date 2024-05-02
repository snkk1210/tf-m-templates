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
    "type"         = "cicd"
  }
}

variable "sfx" {
  type    = string
  default = "01"
}

/**
# Variables for CodeBuild
*/
variable "vpc_id" {
  type    = string
  default = ""
}

variable "codebuild_subnet_ids" {
  type    = list(string)
  default = []
}

variable "buildspec" {
  type    = string
  default = "./deploy_scripts/buildspec.yml"
}

variable "environment" {
  type = object({
    compute_type    = string
    image           = string
    privileged_mode = bool
  })

  default = {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    privileged_mode = true
  }
}

variable "environment_variable" {
  type = object({
    variables = list(object({
      name  = string
      value = string
      type  = string
    }))
  })
}

/** 
# Variables for CodeDeploy
*/
variable "termination_wait_time_in_minutes" {
  type    = number
  default = 1
}

variable "ecs_service" {
  type = object({
    cluster_name = string
    service_name = string
  })

  default = {
    cluster_name = ""
    service_name = ""
  }
}

variable "lb_info" {
  type = object({
    prod_traffic_route_listener_arns = list(string)
    blue_target_group                = string
    green_target_group               = string
  })

  default = {
    prod_traffic_route_listener_arns = []
    blue_target_group                = ""
    green_target_group               = ""
  }
}

/** 
# Variables for CodePipeline
*/
variable "codestarconnections_connection_arn" {
  type    = string
  default = ""
}

variable "repository_name" {
  type    = string
  default = ""
}

variable "branch_name" {
  type    = string
  default = ""
}

variable "task_definition_template_path" {
  type    = string
  default = ""
}

variable "app_spec_template_path" {
  type    = string
  default = ""
}

/** 
# Variables for S3 Bucket
*/
variable "s3_bucket_force_destroy" {
  type    = bool
  default = false
}

variable "artifact_expiration_days" {
  type    = number
  default = 30
}