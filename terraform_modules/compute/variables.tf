variable "public_subnet_id" {
  type        = string
  description = "The ID of the public subnet"
}

variable "public_sg_id" {
  type        = string
  description = "The ID of the public security group"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The IDs of the private subnets"
}

variable "private_sg_id" {
  type        = string
  description = "The ID of the private security group"
}

variable "nat_gateway_id" {
  type        = string
  description = "The ID of the NAT gateway"
}

variable "key_name" {
  type        = string
  description = "The name of the key pair to use for SSH access"
}