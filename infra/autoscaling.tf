# Auto Scaling Group for ECS EC2 instances
resource "aws_autoscaling_group" "ecs" {
  name                = "${terraform.workspace}-ecs-asg"
  vpc_zone_identifier = [aws_subnet.private.id, aws_subnet.private_2.id]
  min_size            = 1
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}-ecs-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}

