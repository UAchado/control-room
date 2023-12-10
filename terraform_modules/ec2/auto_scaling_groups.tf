resource "aws_autoscaling_group" "private" {
  vpc_zone_identifier = var.private_subnet_ids
  health_check_grace_period = 0
  health_check_type = "EC2"

  min_size            = 2
  max_size            = 6

  launch_template {
    id      = aws_launch_template.private_ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}