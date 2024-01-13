/** 
# Target Group
*/

// TagetGroup Blue
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

// TagetGroup Green
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