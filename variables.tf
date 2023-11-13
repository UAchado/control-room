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

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-west-1a", "us-west-1b"]

}

variable "ssh_keys" {
  type        = string
  description = "SSH Keys to be added to the EC2 instances"
  default     = "terraform-key"
  sensitive   = true
}

variable "inventory_db_password" {
  type        = string
  description = "Password for the Inventory Database"
  default     = "test"
  sensitive   = true
}

variable "inventory_db_user" {
  type        = string
  description = "Username for the Inventory Database"
  default     = "test"
  sensitive   = true
}

variable "drop_off_points_db_password" {
  type        = string
  description = "Password for the Drop Off Points Database"
  default     = "test"
  sensitive   = true
}

variable "drop_off_points_db_user" {
  type        = string
  description = "Username for the Drop Off Points Database"
  default     = "test"
  sensitive   = true
}
