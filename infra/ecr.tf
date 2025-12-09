# ECR Repository for Node.js API
resource "aws_ecr_repository" "nodejs_app" {
  name                 = "${terraform.workspace}-nodejs-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${terraform.workspace}-nodejs-app"
  }
}

# ECR Repository for Migration
resource "aws_ecr_repository" "migration" {
  name                 = "${terraform.workspace}-migration"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${terraform.workspace}-migration"
  }
}

# ECR Lifecycle Policy for Node.js App - keep last 10 images
resource "aws_ecr_lifecycle_policy" "nodejs_app" {
  repository = aws_ecr_repository.nodejs_app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# ECR Lifecycle Policy for Migration - keep last 5 images
resource "aws_ecr_lifecycle_policy" "migration" {
  repository = aws_ecr_repository.migration.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

