output "private_ecs_asg_arn" {
  value = aws_autoscaling_group.private.arn
}

output "user_ui_tg_arn" {
  value = aws_lb_target_group.user_ui_tg.arn
}

output "inventory_api_tg_arn" {
  value = aws_lb_target_group.inventory_api_tg.arn
}

output "drop_off_points_api_tg_arn" {
  value = aws_lb_target_group.drop_off_points_api_tg.arn
}