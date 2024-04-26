/**
# Security Group for ALB
*/

resource "aws_security_group" "alb" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-alb-sg${var.sfx}"
  description = "${var.common.project}-${var.common.environment}-${var.common.service_name}-alb-sg${var.sfx}"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-alb-sg${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_security_group_rule" "alb_ingress_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.alb_ingress_cidr_blocks
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_ingress_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.alb_ingress_cidr_blocks
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

/**
# Security Group for ECS
*/

resource "aws_security_group" "ecs" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-sg${var.sfx}"
  description = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-sg${var.sfx}"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-sg${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_security_group_rule" "ecs_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.ecs_ingress_cidr_blocks
  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_ingress_alb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}