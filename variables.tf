variable "region" {
  type = string
  description = "The region to deploy the infrastructure"
  default = "us-west-1"
}

variable "inventory_db_user" {
  type        = string
  description = "The username for the inventory database"
}

variable "inventory_db_password" {
  type        = string
  description = "The password for the inventory database"
  sensitive   = true
}

variable "inventory_db_name" {
  type        = string
  description = "The name for the inventory database"
  default     = "inventory_db"
  
}

variable "drop_off_points_db_user" {
  type        = string
  description = "The username for the drop-off-points database"
}

variable "drop_off_points_db_password" {
  type        = string
  description = "The password for the drop-off-points database"
}

variable "drop_off_points_db_name" {
  type        = string
  description = "The name for the drop-off-points database"
  default     = "points_db"
}

variable "user_ui_image" {
  type        = string
  description = "The image for the user-ui container"
  default     = "334642795591.dkr.ecr.us-west-1.amazonaws.com/user-ui"
}

variable "inventory_api_image_repo" {
  type        = string
  description = "The image for the inventory-api container"
  default     = "334642795591.dkr.ecr.us-west-1.amazonaws.com/inventory-api"
}

variable "drop_off_points_api_image_repo" {
  type        = string
  description = "The image for the drop-off-points-api container"
  default     = "334642795591.dkr.ecr.us-west-1.amazonaws.com/drop-off-points-api"
}

variable "google_api_key" {
  type        = string
  description = "The Google API key"
}

variable "smtp_server" {
  type        = string
  description = "The SMTP server"
}

variable "smtp_port" {
  type        = string
  description = "The SMTP port"
}

variable "email_username" {
  type        = string
  description = "The SMTP username"
}

variable "email_password" {
  type        = string
  description = "The SMTP password"
  sensitive   = true
}
