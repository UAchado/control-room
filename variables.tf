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
  default     = "mankings"
}
