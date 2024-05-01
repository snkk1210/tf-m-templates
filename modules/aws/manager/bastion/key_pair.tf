resource "aws_key_pair" "this" {
  count      = var.key_auth_enabled == true ? 1 : 0
  key_name   = "${var.common.project}-${var.common.environment}-bastion-ec2-keypair${var.sfx}"
  public_key = file("${path.module}/public_key/${var.common.environment}_bastion.pub")
}