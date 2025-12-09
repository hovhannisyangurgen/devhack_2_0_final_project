resource "aws_cloudwatch_log_group" "nodejs_app" {
  name              = "/ecs/nodejs-app"
  retention_in_days = 7

  tags = {
    Name = terraform.workspace
  }
}

resource "aws_cloudwatch_log_group" "migration" {
  name              = "/ecs/migration"
  retention_in_days = 7

  tags = {
    Name = terraform.workspace
  }
}

