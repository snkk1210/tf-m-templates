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
    compute_type                = string
    image                       = string
    type                        = string
    image_pull_credentials_type = string
    privileged_mode             = bool
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
# CodeDeploy
*/
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

variable "prod_traffic_route_listener_arns" {
  type = list(string)
}

variable "blue_target_group" {
  type = string
}

variable "green_target_group" {
  type = string
}

variable "termination_wait_time_in_minutes" {
  type    = number
  default = 60
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

variable "task_definition_template_path" {
  type    = string
  default = ""
}

variable "app_spec_template_path" {
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