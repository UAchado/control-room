output "ecs_asg_arn" {
  value = aws_autoscaling_group.asg.arn
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

output "ui_lb_dns_name" {
  value = aws_lb.ui_lb.dns_name
}

output "inventory_lb_dns_name" {
  value = aws_lb.inventory_lb.dns_name
}

output "points_lb_dns_name" {
  value = aws_lb.points_lb.dns_name
}