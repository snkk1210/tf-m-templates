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

variable "alb_subnet_ids" {
  type    = list(string)
  default = []
}

variable "ecs_subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_group_rules_alb" {
  type    = list(string)
  default = []
}

variable "load_balancer" {
  type = object({
    internal           = bool
    load_balancer_type = string
    access_logs_bucket = string
    access_logs_prefix = string
  })

  default = {
    internal           = false
    load_balancer_type = ""
    access_logs_bucket = ""
    access_logs_prefix = ""

  }
}

variable "lb_target_group" {
  type = object({
    port        = number
    protocol    = string
    target_type = string
  })

  default = {
    port        = 0
    protocol    = ""
    target_type = ""
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
    interval            = 0
    path                = ""
    port                = 0
    protocol            = ""
    timeout             = 0
    unhealthy_threshold = 0
    matcher             = ""
  }
}

variable "lb_listener_http" {
  type = object({
    port           = number
    protocol       = string
    default_action = map(string)
  })

  default = {
    port           = 80
    protocol       = ""
    default_action = {}
  }
}

variable "lb_listener_https" {
  type = object({
    port            = number
    protocol        = string
    certificate_arn = string
    ssl_policy      = string
    default_action  = map(string)
  })

  default = {
    port            = 443
    protocol        = ""
    certificate_arn = ""
    ssl_policy      = ""
    default_action  = {}
  }
}

variable "ecr_repository_web" {
  type = object({
    image_tag_mutability          = string
    scan_on_push                  = bool
    lifecycle_policy_count_number = number
  })

  default = {
    image_tag_mutability          = ""
    scan_on_push                  = false
    lifecycle_policy_count_number = 15
  }
}

variable "ecr_repository_app" {
  type = object({
    image_tag_mutability          = string
    scan_on_push                  = bool
    lifecycle_policy_count_number = number
  })

  default = {
    image_tag_mutability          = ""
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
    launch_type                = ""
    platform_version           = ""
    desired_count              = 0
    deployment_controller_type = ""
  }
}


variable "appautoscaling_target" {
  type = object({
    max_capacity       = number
    min_capacity       = number
    scalable_dimension = string
    service_namespace  = string
  })
  default = {
    max_capacity       = 0
    min_capacity       = 0
    scalable_dimension = ""
    service_namespace  = ""
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
    policy_type            = ""
    predefined_metric_type = ""
    statistic              = ""
    target_value           = 0
    disable_scale_in       = false
    scale_in_cooldown      = 0
    scale_out_cooldown     = 0
  }
}

variable "ecs_log_retention_in_days" {
  type    = number
  default = 14
}