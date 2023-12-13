/** 
# Cloud9
*/
resource "aws_cloud9_environment_ec2" "this" {
  name            = "${var.common.project}-${var.common.environment}-eks-env"
  instance_type   = var.instance_type
  image_id        = var.image_id
  connection_type = "CONNECT_SSM"
}

data "aws_instance" "this" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
    aws_cloud9_environment_ec2.this.id]
  }
}

output "cloud9_url" {
  value = "https://${var.common.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.this.id}"
}

output "cloud9_instance_id" {
  value = data.aws_instance.this.id
}