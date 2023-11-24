variable "private_subnet_ids" {
  type        = list(string)
  description = "The IDs of the private subnets"
}

variable "inventory_db_password" {
  type        = string
  description = "Password for the Inventory Database"
  sensitive   = true
}

variable "inventory_db_user" {
  type        = string
  description = "Username for the Inventory Database"
  sensitive   = true
}

variable "drop_off_points_db_password" {
  type        = string
  description = "Password for the Drop Off Points Database"
  sensitive   = true
}

variable "drop_off_points_db_user" {
  type        = string
  description = "Username for the Drop Off Points Database"
  sensitive   = true
}