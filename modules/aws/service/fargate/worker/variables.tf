/**
# Variables For WEBAPP
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

variable "vpc_id" {
  type    = string
  default = ""
}

variable "ecs_subnet_ids" {
  type    = list(string)
  default = []
}

variable "lb_target_group" {
  type = object({
    port        = number
    protocol    = string
    target_type = string
  })

  default = {
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
  }
}

variable "lb_health_check" {
  type = object({
    interval            = number
    path                = string
    port                = number
    protocol            = string
    timeout             = number
    unhealthy_threshold = number
    matcher             = string
  })
  default = {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

variable "ecr_repository_worker" {
  type = object({
    image_tag_mutability          = string
    scan_on_push                  = bool
    lifecycle_policy_count_number = number
  })

  default = {
    image_tag_mutability          = "MUTABLE"
    scan_on_push                  = false
    lifecycle_policy_count_number = 15
  }
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