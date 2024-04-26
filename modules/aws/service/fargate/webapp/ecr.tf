/**
# ECR
*/

resource "aws_ecr_repository" "web" {
  name                 = "${var.common.project}-${var.common.environment}-${var.common.service_name}-web-ecr${var.sfx}"
  image_tag_mutability = var.ecr_repository_web.image_tag_mutability
  force_delete         = var.ecr_repository_web.force_delete

  image_scanning_configuration {
    scan_on_push = var.ecr_repository_web.scan_on_push
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-web-ecr${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "web" {
  repository = aws_ecr_repository.web.name
  policy = jsonencode(
    {
      rules = [
        {
          action = {
            type = "expire"
          }
          description  = "Delete images, leaving only the ${var.ecr_repository_web.lifecycle_policy_count_number} most recent."
          rulePriority = 1
          selection = {
            countNumber = "${var.ecr_repository_web.lifecycle_policy_count_number}"
            countType   = "imageCountMoreThan"
            tagStatus   = "any"
          }
        },
      ]
    }
  )
}

resource "aws_ecr_repository" "app" {
  name                 = "${var.common.project}-${var.common.environment}-${var.common.service_name}-app-ecr${var.sfx}"
  image_tag_mutability = var.ecr_repository_app.image_tag_mutability
  force_delete         = var.ecr_repository_app.force_delete

  image_scanning_configuration {
    scan_on_push = var.ecr_repository_app.scan_on_push
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-app-ecr${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "app_policy" {
  repository = aws_ecr_repository.app.name
  policy = jsonencode(
    {
      rules = [
        {
          action = {
            type = "expire"
          }
          description  = "Delete images, leaving only the ${var.ecr_repository_app.lifecycle_policy_count_number} most recent."
          rulePriority = 1
          selection = {
            countNumber = "${var.ecr_repository_app.lifecycle_policy_count_number}"
            countType   = "imageCountMoreThan"
            tagStatus   = "any"
          }
        },
      ]
    }
  )
}