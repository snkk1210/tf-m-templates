/**
# ALB
*/

// ALB
resource "aws_lb" "alb" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-alb"
  internal           = var.load_balancer.internal
  load_balancer_type = var.load_balancer.load_balancer_type
  security_groups = [
    aws_security_group.alb.id
  ]
  subnets = var.alb_subnet_ids

  access_logs {
    bucket  = var.load_balancer.access_logs_bucket
    prefix  = var.load_balancer.access_logs_prefix
    enabled = true
  }

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-alb"
    Createdby = "Terraform"
  }
}

// ALB TagetGroup Blue
resource "aws_lb_target_group" "blue" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-tg-1"
  port        = var.lb_target_group.port
  protocol    = var.lb_target_group.protocol
  target_type = var.lb_target_group.target_type
  vpc_id      = var.vpc_id

  health_check {
    interval            = var.lb_health_check.interval
    path                = var.lb_health_check.path
    port                = var.lb_health_check.port
    protocol            = var.lb_health_check.protocol
    timeout             = var.lb_health_check.timeout
    unhealthy_threshold = var.lb_health_check.unhealthy_threshold
    matcher             = var.lb_health_check.matcher
  }

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-tg-1"
    Createdby = "Terraform"
  }
}

// ALB TagetGroup Green
resource "aws_lb_target_group" "green" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-tg-2"
  port        = var.lb_target_group.port
  protocol    = var.lb_target_group.protocol
  target_type = var.lb_target_group.target_type
  vpc_id      = var.vpc_id

  health_check {
    interval            = var.lb_health_check.interval
    path                = var.lb_health_check.path
    port                = var.lb_health_check.port
    protocol            = var.lb_health_check.protocol
    timeout             = var.lb_health_check.timeout
    unhealthy_threshold = var.lb_health_check.unhealthy_threshold
    matcher             = var.lb_health_check.matcher
  }

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-tg-2"
    Createdby = "Terraform"
  }
}

// ALB Lister 80
resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.lb_listener_http.port
  protocol          = var.lb_listener_http.protocol

  default_action {
    type = var.lb_listener_http.default_action.type
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

// ALB Lister 443
resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.lb_listener_https.port
  protocol          = var.lb_listener_https.protocol
  ssl_policy        = var.lb_listener_https.ssl_policy
  certificate_arn   = var.lb_listener_https.certificate_arn

  default_action {
    type             = var.lb_listener_https.default_action.type
    target_group_arn = aws_lb_target_group.blue.arn
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}