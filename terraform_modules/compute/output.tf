output "user_ui_ip" {
  value = aws_instance.user_ui.public_ip
}

output "inventory_api_ip" {
    value = aws_instance.inventory_api.private_ip
}

output "drop_off_points_api_ip" {
    value = aws_instance.drop_off_points_api.private_ip
}