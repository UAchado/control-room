resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_grace_period = 0
  health_check_type         = "EC2"

  min_size         = 1
  desired_capacity = 3
  max_size         = 5

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

# resource "aws_autoscaling_policy" "scale_up" {
#     name                   = "scale_up"
#     scaling_adjustment     = 1
#     adjustment_type        = "ChangeInCapacity"
#     cooldown               = 300
#     autoscaling_group_name = aws_autoscaling_group.asg.name
# }

# resource "aws_autoscaling_policy" "scale_down" {
#     name                   = "scale_down"
#     scaling_adjustment     = -1
#     adjustment_type        = "ChangeInCapacity"
#     cooldown               = 300
#     autoscaling_group_name = aws_autoscaling_group.asg.name
# }

# resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
#     alarm_name          = "scale_up_on_cpu"
#     comparison_operator = "GreaterThanOrEqualToThreshold"
#     evaluation_periods  = "2"
#     metric_name         = "CPUUtilization"
#     namespace           = "AWS/EC2"
#     period              = "120"
#     statistic           = "Average"
#     threshold           = "80"
#     alarm_description   = "This metric monitors ec2 cpu utilization"
#     alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
#     dimensions = {
#         AutoScalingGroupName = aws_autoscaling_group.asg.name
#     }
# }

# resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
#     alarm_name          = "scale_down_on_cpu"
#     comparison_operator = "LessThanOrEqualToThreshold"
#     evaluation_periods  = "2"
#     metric_name         = "CPUUtilization"
#     namespace           = "AWS/EC2"
#     period              = "120"
#     statistic           = "Average"
#     threshold           = "40"
#     alarm_description   = "This metric monitors ec2 cpu utilization"
#     alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
#     dimensions = {
#         AutoScalingGroupName = aws_autoscaling_group.asg.name
#     }
# }
