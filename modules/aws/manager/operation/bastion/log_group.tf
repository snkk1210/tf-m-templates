/** 
# NOTE: Log For Bastion
*/
resource "aws_cloudwatch_log_group" "log" {
  name              = "/ec2/${var.common.environment}/var/log/secure"
  retention_in_days = var.bastion_log_retention_in_days

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-bastion-ec2-log-group01"
    Environment = var.common.environment
  }
}