resource "aws_security_group" "this" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-rds-sg${var.sfx}"
  description = "${var.common.project}-${var.common.environment}-${var.common.service_name}-rds-sg${var.sfx}"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-rds-sg${var.sfx}"
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
  from_port         = var.rds_cluster.port
  to_port           = var.rds_cluster.port
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidr_blocks
  security_group_id = aws_security_group.this.id
}