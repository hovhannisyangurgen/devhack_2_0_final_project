variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "project1"
}

variable "key_name" {
  description = "Name of the AWS key pair for EC2 instances"
  type        = string
  default     = ""
}

variable "container_image" {
  description = "Docker image for the Node.js application"
  type        = string
  default     = "nginx:latest"  # Replace with your actual image
}

variable "migration_container_image" {
  description = "Docker image for the migration task"
  type        = string
  default     = "nginx:latest"  # Replace with your actual migration image
}
