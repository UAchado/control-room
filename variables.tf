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
