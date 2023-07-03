resource "aws_key_pair" "key_pair" {
  key_name   = "${var.common.project}-${var.common.environment}-bastion-ec2-keypair01"
  public_key = file("${path.module}/public_key/${var.common.environment}_bastion.pub")
}