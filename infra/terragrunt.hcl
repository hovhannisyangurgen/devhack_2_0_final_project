remote_state {
  backend = "s3"
  config = {
    # Change the bucket to one you have access to
    bucket         = "terraform-states-academy-devops"
    key            = "terraform/infra/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
    # Remove access_key and secret_key from config for better security
    # and to avoid issues with AWS SDK credential chain
    # access_key     = get_env("AWS_ACCESS_KEY_ID", "")
    # secret_key     = get_env("AWS_SECRET_ACCESS_KEY", "")
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  provider "aws" {
    region                  = "us-east-1"
  }
  EOF
}

generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  terraform {
    backend "s3" {}
  }
  EOF
}
