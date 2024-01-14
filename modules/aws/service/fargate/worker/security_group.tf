/**
# Security Group
*/

// ECS セキュリティグループ
resource "aws_security_group" "ecs" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-sg"
  description = "Security group for ECS"
  vpc_id      = var.vpc_id

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-sg"
    Createdby = "Terraform"
  }
}

// ECS アウトバウンドルール
resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}

// ECS インバウンドルール
resource "aws_security_group_rule" "ecs_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.ecs_ingress_cidr_blocks
  security_group_id = aws_security_group.ecs.id
}