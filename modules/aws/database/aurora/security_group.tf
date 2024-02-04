resource "aws_security_group" "this" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-sg${var.sfx}"
  description = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-sg${var.sfx}"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-sg${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.aurora_ingress
  security_group_id = aws_security_group.this.id
}