# Launch template for ECS EC2 instances
resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${terraform.workspace}-ecs-"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = "t3.medium"
  key_name      = var.key_name != "" ? var.key_name : null

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  vpc_security_group_ids = [aws_security_group.ecs_sg.id]

  user_data = base64encode(templatefile("${path.module}/ecs_user_data.sh", {
    cluster_name = aws_ecs_cluster.main.name
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${terraform.workspace}-ecs-instance"
    }
  }

  tags = {
    Name = terraform.workspace
  }
}

# Data source for ECS optimized AMI
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

