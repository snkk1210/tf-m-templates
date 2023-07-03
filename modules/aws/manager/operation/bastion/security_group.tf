resource "aws_security_group" "bastion" {
  name        = "${var.common.project}-${var.common.environment}-bastion-ec2-sg"
  description = "Security group for Bastion EC2"
  vpc_id      = var.vpc_id
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-bastion-ec2-sg"
    Environment = var.common.environment
  }
}

resource "aws_security_group_rule" "bastion_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.security_group_rules_bastion
  security_group_id = aws_security_group.bastion.id

  lifecycle {
    ignore_changes = [
      //cidr_blocks
    ]
  }
}