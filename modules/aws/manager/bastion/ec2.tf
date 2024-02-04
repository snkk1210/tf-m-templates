/** 
# Bastion
*/
resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = var.key_auth_enabled ? aws_key_pair.key_pair[0].id : null
  subnet_id                   = var.subnet_ids
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.this.name
  user_data                   = file("${path.module}/scripts/userdata.sh")

  root_block_device {
    volume_type           = var.root_block_device.volume_type
    volume_size           = var.root_block_device.volume_size
    delete_on_termination = var.root_block_device.delete_on_termination
    encrypted             = var.root_block_device.encrypted
    kms_key_id            = var.root_block_device.encrypted ? data.aws_kms_key.ebs.key_id : null
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-bastion${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }

  lifecycle {
    ignore_changes = all
  }

}

resource "aws_eip" "bastion" {
  count = var.global_ip_enabled ? 1 : 0

  instance = aws_instance.this.id
  domain   = "vpc"

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-bastion-eip${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}