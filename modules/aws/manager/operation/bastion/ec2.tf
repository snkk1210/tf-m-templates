/** 
# NOTE: Bastion KMS
*/
resource "aws_kms_key" "bastion_storage" {
  description             = "${var.common.project}-${var.common.environment}-bastion-storage-kms01"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

resource "aws_kms_alias" "bastion_storage" {
  name          = "alias/${var.common.project}/${var.common.environment}/bastion_storage_kms_key01"
  target_key_id = aws_kms_key.bastion_storage.id
}

/** 
# NOTE: Bastion
*/
resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = aws_key_pair.key_pair.id
  subnet_id                   = var.subnet_ids
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  user_data                   = file("${path.module}/scripts/userdata.sh")

  root_block_device {
    volume_type           = var.root_block_device.volume_type
    volume_size           = var.root_block_device.volume_size
    delete_on_termination = var.root_block_device.delete_on_termination
    encrypted             = var.root_block_device.encrypted
    kms_key_id            = var.root_block_device.encrypted ? aws_kms_key.bastion_storage.key_id : null
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-bastion01"
    Environment = var.common.environment
  }

  lifecycle {
    ignore_changes = all
  }

}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"

  tags = {
    Name = "${var.common.project}-${var.common.environment}-bastion-eip01"
  }
}