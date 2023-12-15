/**
# CodeCommit
*/
resource "aws_codecommit_repository" "this" {
  repository_name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-repository"
  description     = "${var.common.environment} ${var.common.service_name} Repository"

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-repository"
    Createdby = "Terraform"
  }
}