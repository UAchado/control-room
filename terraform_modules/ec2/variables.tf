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

variable "lbs_sg_id" {
  type = string
}

variable "instances_sg_id" {
  type = string
}

variable "public_instances_sg_id" {
  type = string
}