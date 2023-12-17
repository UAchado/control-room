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

variable "certificate_arn" {
  type = string
}