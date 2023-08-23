/**
# Security Group
*/

// ALB セキュリティグループ
resource "aws_security_group" "alb" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-alb-sg"
    Createdby = "Terraform"
  }
}

// ECS セキュリティグループ
resource "aws_security_group" "ecs" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-sg"
  description = "Security group for ECS"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-sg"
    Createdby = "Terraform"
  }
}

// ALB インバウンドルール 80
resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.security_group_rules_alb
  security_group_id = aws_security_group.alb.id

  lifecycle {
    ignore_changes = [
      cidr_blocks
    ]
  }
}

// ALB インバウンドルール 443
resource "aws_security_group_rule" "alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.security_group_rules_alb
  security_group_id = aws_security_group.alb.id

  lifecycle {
    ignore_changes = [
      //cidr_blocks
    ]
  }
}

// ECS インバウンドルール 80
resource "aws_security_group_rule" "ecs_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs.id
}

// ALB アウトバウンドルール
resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

// ecs アウトバウンドルール
resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}