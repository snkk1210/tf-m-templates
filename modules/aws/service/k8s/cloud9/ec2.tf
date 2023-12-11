/**
# EC2
 */
resource "null_resource" "associate_iam_instance_profile" {
  depends_on = [aws_cloud9_environment_ec2.this]

  provisioner "local-exec" {
    command     = <<EOT
      aws ec2 disassociate-iam-instance-profile --association-id $(aws ec2 describe-iam-instance-profile-associations --filters Name=instance-id,Values=${data.aws_instance.this.id} --query 'IamInstanceProfileAssociations[*].AssociationId' --output text)
      aws ec2 associate-iam-instance-profile --instance-id ${data.aws_instance.this.id} --iam-instance-profile Name=${aws_iam_instance_profile.cloud9_profile.name}
    EOT
  }
}