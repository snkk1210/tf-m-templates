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
  type    = string
  default = "01"
}

variable "vpc_id" {
  type    = string
  default = ""
}

/** 
# Variables for ALB
*/

variable "lb" {
  type = object({
    internal            = bool
    load_balancer_type  = string
    security_groups     = list(string)
    subnet_ids          = list(string)
    access_logs_enabled = bool
  })

  default = {
    internal            = false
    load_balancer_type  = "application"
    security_groups     = []
    subnet_ids          = []
    access_logs_enabled = true
  }
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

variable "lb_listener_http" {
  type = object({
    port           = number
    protocol       = string
    default_action = map(string)
  })

  default = {
    port     = 80
    protocol = "HTTP"
    default_action = {
      type = "redirect"
    }
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
    protocol        = "HTTPS"
    certificate_arn = ""
    ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
    default_action = {
      type = "forward"
    }
  }
}

variable "alb_ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

/** 
# Variables for AutoScailing
*/

variable "ecs_cluster_name" {
  type    = string
  default = ""
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

/** 
# Variables for ECS
*/

variable "ecs_subnet_ids" {
  type    = list(string)
  default = []
}

variable "ecs_task" {
  type = object({
    cpu    = number
    memory = number
  })

  default = {
    cpu    = 256
    memory = 512
  }
}

variable "ecs_service" {
  type = object({
    cluster                    = string
    launch_type                = string
    platform_version           = string
    desired_count              = number
    assign_public_ip           = bool
    deployment_controller_type = string
    enable_execute_command     = bool
  })

  default = {
    cluster                    = ""
    launch_type                = "FARGATE"
    platform_version           = "1.4.0"
    desired_count              = 1
    assign_public_ip           = false
    deployment_controller_type = "ECS"
    enable_execute_command     = true
  }
}

variable "ecs_ingress_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "ecs_log_retention_in_days" {
  type    = number
  default = 14
}

/** 
# Variables for ECR
*/

variable "ecr_repository_web" {
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

variable "ecr_repository_app" {
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
# Variables for S3
*/

variable "force_destroy" {
  type    = bool
  default = false
}

variable "versioning_configuration" {
  type    = string
  default = "Disabled"
}

variable "log_rule" {
  type = object({
    status          = string
    glacier_days    = number
    expiration_days = number
  })

  default = {
    status          = "Enabled"
    glacier_days    = 365
    expiration_days = 730
  }
}



