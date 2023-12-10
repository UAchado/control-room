variable "public_sg_id" {
  type = string
}

variable "private_sg_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}