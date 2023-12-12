# output "user_ui_ip" {
#   value = module.compute.user_ui_ip
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

output "lb_dns_name" {
  value = module.ec2.ui_lb_dns_name
}
