# ECR Repository URLs
output "nodejs_app_ecr_repository_url" {
  description = "URL of the ECR repository for the Node.js application"
  value       = aws_ecr_repository.nodejs_app.repository_url
}

output "migration_ecr_repository_url" {
  description = "URL of the ECR repository for the migration task"
  value       = aws_ecr_repository.migration.repository_url
}

output "nodejs_app_ecr_repository_arn" {
  description = "ARN of the ECR repository for the Node.js application"
  value       = aws_ecr_repository.nodejs_app.arn
}

output "migration_ecr_repository_arn" {
  description = "ARN of the ECR repository for the migration task"
  value       = aws_ecr_repository.migration.arn
}

