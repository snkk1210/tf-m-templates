/**
# ECR
*/
resource "aws_ecr_repository" "web" {
  name                 = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecr-web"
  image_tag_mutability = var.ecr_repository_web.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_repository_web.scan_on_push
  }

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecr-web"
    Createdby = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "web_policy" {
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
  name                 = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecr-app"
  image_tag_mutability = var.ecr_repository_app.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_repository_app.scan_on_push
  }

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecr-app"
    Createdby = "Terraform"
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