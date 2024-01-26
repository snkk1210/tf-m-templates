/** 
# CloudWatch Logs
*/
resource "aws_cloudwatch_log_group" "this" {
  name              = "/ec2/${var.common.project}-${var.common.environment}-bastion${var.sfx}"
  retention_in_days = var.bastion_log_retention_in_days

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-bastion-ec2-log-group${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}