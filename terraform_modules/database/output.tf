output "inventory_db_connection_string" {
  value = "mysql+mysqlconnector://${var.inventory_db_user}:${var.inventory_db_password}@${aws_db_instance.inventory_db.address}/${var.inventory_db_name}"
  description = "Connection string for Inventory DB"
}

output "drop_off_points_db_connection_string" {
  value = "mysql+mysqlconnector://${var.drop_off_points_db_user}:${var.drop_off_points_db_password}@${aws_db_instance.drop_off_points_db.address}/${var.drop_off_points_db_name}"
  description = "Connection string for Drop-Off Points DB"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.image_bucket.bucket
  description = "Name of the S3 bucket for images"
}

output "access_key" {
  value = aws_iam_access_key.boto3_user_key.id
}

output "secret_key" {
  value = aws_iam_access_key.boto3_user_key.secret
}