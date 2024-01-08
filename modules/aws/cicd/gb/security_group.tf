/**
# Security Group for CodeBuild
*/

// CodeBuild Security Group
resource "aws_security_group" "codebuild" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-sg"
  description = "Security group for CodeBuild"
  vpc_id      = var.vpc_id
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-sg"
    Environment = var.common.environment
  }
}

resource "aws_security_group_rule" "codebuild_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.codebuild.id
}