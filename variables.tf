variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.0.0/25"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.0.128/26", "10.0.0.192/26"]
}

variable "ssh_keys" {
  type        = string
  description = "SSH Keys to be added to the EC2 instances"
  default     = "terraform-key"
}

variable "inventory_db_password" {
  type        = string
  description = "Password for the Inventory Database"
  default     = "test"
}

variable "inventory_db_user" {
  type        = string
  description = "Username for the Inventory Database"
  default     = "test"
}

variable "drop_off_points_db_password" {
  type        = string
  description = "Password for the Drop Off Points Database"
  default     = "test"
}

variable "drop_off_points_db_user" {
  type        = string
  description = "Username for the Drop Off Points Database"
  default     = "test"
}