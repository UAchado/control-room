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

variable "drop_off_points_db_user" {
  type        = string
  description = "The username for the drop-off-points database"
}

variable "drop_off_points_db_password" {
  type        = string
  description = "The password for the drop-off-points database"
}

variable "user_ui_image" {
  type        = string
  description = "The image for the user-ui container"
  default     = "334642795591.dkr.ecr.us-west-1.amazonaws.com/user-ui"
}

variable "inventory_api_image" {
  type        = string
  description = "The image for the inventory-api container"
  default     = "334642795591.dkr.ecr.us-west-1.amazonaws.com/inventory-api"
}

variable "drop_off_points_api_image" {
  type        = string
  description = "The image for the drop-off-points-api container"
  default     = "334642795591.dkr.ecr.us-west-1.amazonaws.com/drop-off-points-api"
}

variable "inventory_api_url" {
  type = string
  description = "The url for the inventory api"
  default = "https://x6zv6w9f35.execute-api.us-west-1.amazonaws.com/test/inventory"
}

variable "drop_off_points_api_url" {
  type = string
  description = "The url for the drop-off-points api"
  default = "https://x6zv6w9f35.execute-api.us-west-1.amazonaws.com/test/drop-off-points"
}