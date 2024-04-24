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
    "type"         = "ci"
  }
}

variable "sfx" {
  type    = string
  default = "01"
}

/** 
# Variables for CodeBuild
*/
variable "source" {
  type = object({
    location        = string
    git_clone_depth = number
    buildspec       = string
  })

  default = {
    "location"        = ""
    "git_clone_depth" = 1
    "buildspec"       = ""
  }
}

variable "environment" {
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

variable "environment_variable" {
  type = object({
    i = list(object({
      name  = string
      value = string
      type  = string
    }))
  })
}

variable "filter_groups" {
  type = list(object({
    event_pattern = string
    file_pattern  = string
  }))
}