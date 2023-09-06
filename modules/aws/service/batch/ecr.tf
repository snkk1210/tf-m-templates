/**
# ECR
*/
resource "aws_ecr_repository" "batch" {
  name                 = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecr-batch"
  image_tag_mutability = var.ecr_repository_batch.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_repository_batch.scan_on_push
  }

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecr-batch"
    Createdby = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "batch_policy" {
  repository = aws_ecr_repository.batch.name
  policy = jsonencode(
    {
      rules = [
        {
          action = {
            type = "expire"
          }
          description  = "Delete images, leaving only the ${var.ecr_repository_batch.lifecycle_policy_count_number} most recent."
          rulePriority = 1
          selection = {
            countNumber = "${var.ecr_repository_batch.lifecycle_policy_count_number}"
            countType   = "imageCountMoreThan"
            tagStatus   = "any"
          }
        },
      ]
    }
  )
}