# vpc
variable "region" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

# security group
variable "instances_sg_id" {
  type = string
}

# auto scaling group
variable "ecs_asg_arn" {
  type = string
}

# target groups
variable "user_ui_tg_arn" {
  type = string
}

variable "inventory_api_tg_arn" {
  type = string
}

variable "drop_off_points_api_tg_arn" {
  type = string
}

# repos
variable "user_ui_image" {
  type = string
}

variable "inventory_api_image_repo" {
  type = string
}

variable "drop_off_points_api_image_repo" {
  type = string
}

# google api key
variable "google_api_key" {
  type = string
}

# urls
variable "inventory_lb_dns_name" {
  type = string
}

variable "points_lb_dns_name" {
  type = string
}

# databases
variable "inventory_db_connection_string" {
  type = string
}

variable "drop_off_points_db_connection_string" {
  type = string
}

# emails
variable "smtp_server" {
  type = string
}

variable "smtp_port" {
  type = string
}

variable "email_username" {
  type = string
}

variable "email_password" {
  type = string
}

variable "cognito_issuer" {
  type = string
}

variable "cognito_audience" {
  type = string
}
