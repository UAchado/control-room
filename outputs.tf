output "user_ui_ip" {
  value = module.compute.user_ui_ip
}   

output "management_ui_ip" {
  value = module.compute.management_ui_ip
}

output "inventory_api_ip" {
  value = module.compute.inventory_api_ip
}

output "drop_off_points_api_ip" {
  value = module.compute.drop_off_points_api_ip
}
