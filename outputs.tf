# output "user_ui_ip" {
#   value = module.compute.user_ui_ip
# }   

# output "inventory_api_ip" {
#   value = module.compute.inventory_api_ip
# }

# output "drop_off_points_api_ip" {
#   value = module.compute.drop_off_points_api_ip
# }

output "inventory_db_connection_string" {
  value = module.database.inventory_db_connection_string
  sensitive = true
}

output "drop_off_points_db_connection_string" {
  value = module.database.drop_off_points_db_connection_string
  sensitive = true
}

output "s3_bucket_name" {
  value = module.database.s3_bucket_name
}