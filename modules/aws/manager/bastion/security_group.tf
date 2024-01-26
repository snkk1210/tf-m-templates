resource "aws_security_group" "this" {
  name        = "${var.common.project}-${var.common.environment}-bastion-ec2-sg${var.sfx}"
  description = "Security group for Bastion EC2"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-bastion-ec2-sg${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_security_group_rule" "bastion_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "bastion_ingress" {
  count = var.key_auth_enabled ? 1 : 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.bastion_ingress
  security_group_id = aws_security_group.this.id
}