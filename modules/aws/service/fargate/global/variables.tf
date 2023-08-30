/**
# COMMON
*/
variable "common" {
  type = object({
    project     = string
    environment = string
  })

  default = {
    "project"     = ""
    "environment" = ""
  }
}

/**
# ECS
*/
variable "ecs_cluster" {
  type = map(string)
}