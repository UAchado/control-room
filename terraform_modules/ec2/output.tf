output "ecs_asg_arn" {
  value = aws_autoscaling_group.asg.arn
}

output "user_ui_tg_arn" {
  value = aws_lb_target_group.ui_tg.arn
}

output "inventory_api_tg_arn" {
  value = aws_lb_target_group.inventory_tg.arn
}

output "drop_off_points_api_tg_arn" {
  value = aws_lb_target_group.points_tg.arn
}

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}