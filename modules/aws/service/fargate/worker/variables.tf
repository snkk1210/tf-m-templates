/**
# Variables for COMMON
*/
variable "common" {
  type = object({
    project      = string
    environment  = string
    service_name = string
    region       = string
  })

  default = {
    project      = ""
    environment  = ""
    service_name = ""
    region       = ""
  }
}

variable "sfx" {
  type = string
  default = "01"
}

/**
# Variables for ECS
*/
variable "vpc_id" {
  type    = string
  default = ""
}

variable "ecs_subnet_ids" {
  type    = list(string)
  default = []
}

variable "ecs_task" {
  type = object({
    cpu          = number
    memory       = number
    network_mode = string
  })
  default = {
    cpu          = 256
    memory       = 512
    network_mode = "awsvpc"
  }
}

variable "ecs_cluster_id" {
  type    = string
  default = ""
}

variable "ecs_cluster_name" {
  type    = string
  default = ""
}

variable "ecs_service" {
  type = object({
    launch_type                = string
    platform_version           = string
    desired_count              = number
    deployment_controller_type = string
  })
  default = {
    launch_type                = "FARGATE"
    platform_version           = "1.4.0"
    desired_count              = 1
    deployment_controller_type = "ECS"
  }
}

variable "ecs_ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

/**
# Variables for ECR
*/
variable "ecr_repository" {
  type = object({
    image_tag_mutability          = string
    force_delete                  = bool
    scan_on_push                  = bool
    lifecycle_policy_count_number = number
  })

  default = {
    image_tag_mutability          = "MUTABLE"
    force_delete                  = false
    scan_on_push                  = false
    lifecycle_policy_count_number = 15
  }
}

/**
# Variables for Autoscaling
*/
variable "appautoscaling_target" {
  type = object({
    max_capacity       = number
    min_capacity       = number
    scalable_dimension = string
    service_namespace  = string
  })
  default = {
    max_capacity       = 1
    min_capacity       = 1
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace  = "ecs"
  }
}

variable "appautoscaling_policy" {
  type = object({
    policy_type            = string
    predefined_metric_type = string
    statistic              = string
    target_value           = number
    disable_scale_in       = bool
    scale_in_cooldown      = number
    scale_out_cooldown     = number
  })
  default = {
    policy_type            = "TargetTrackingScaling"
    predefined_metric_type = "ECSServiceAverageCPUUtilization"
    statistic              = "Maximum"
    target_value           = 40
    disable_scale_in       = false
    scale_in_cooldown      = 300
    scale_out_cooldown     = 300
  }
}

variable "ecs_log_retention_in_days" {
  type    = number
  default = 14
}