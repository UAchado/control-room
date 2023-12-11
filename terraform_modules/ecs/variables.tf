variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_sg_id" {
  type = string
}

variable "private_sg_id" {
  type = string
}

variable "private_ecs_asg_arn" {
  type = string
}

variable "user_ui_tg_arn" {
  type = string
}

variable "inventory_api_tg_arn" {
  type = string
}

variable "drop_off_points_api_tg_arn" {
  type = string
}

variable "user_ui_image" {
  type = string
}

variable "inventory_api_image_repo" {
  type = string
}

variable "drop_off_points_api_image_repo" {
  type = string
}

variable "google_api_key" {
  type = string
}

variable "inventory_lb_dns_name" {
  type = string
}

variable "points_lb_dns_name" {
  type = string
}

variable "inventory_db_connection_string" {
  type = string
}

variable "drop_off_points_db_connection_string" {
  type = string
}

variable "region" {
  type = string
}
