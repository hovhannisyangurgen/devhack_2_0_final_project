# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${terraform.workspace}-cluster"
  tags = {
    Name = terraform.workspace
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "nodejs_app" {
  family                   = "${terraform.workspace}-nodejs-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "nodejs-app"
      image     = "${aws_ecr_repository.nodejs_app.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 4567
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "APP_PORT"
          value = "4567"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.nodejs_app.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = terraform.workspace
  }
}

# ECS Service
resource "aws_ecs_service" "nodejs_app" {
  name            = "${terraform.workspace}-nodejs-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nodejs_app.arn
  desired_count   = 2
  launch_type     = "EC2"

  network_configuration {
    subnets          = [aws_subnet.private.id, aws_subnet.private_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "nodejs-app"
    container_port   = 4567
  }

  depends_on = [
    aws_lb_listener.main,
    aws_autoscaling_group.ecs
  ]

  tags = {
    Name = terraform.workspace
  }
}

# ECS Task Definition for Migrations (no service - run as one-off task)
resource "aws_ecs_task_definition" "migration" {
  family                   = "${terraform.workspace}-migration"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "migration"
      image     = "${aws_ecr_repository.migration.repository_url}:latest"
      essential = true

      environment = [
        {
          name  = "NODE_ENV"
          value = "dev"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.migration.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = terraform.workspace
  }
}

