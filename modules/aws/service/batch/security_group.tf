/**
# Security Group For Batch
*/
resource "aws_security_group" "ecs" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-ecs-sg"
  description = "Security group for ${var.common.service_name} ECS"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-ecs-sg"
    Environment = var.common.environment
  }
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}