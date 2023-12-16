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

# env var apis
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

# env var ui
variable "google_api_key" {
  type = string
}

variable "vite_client_id" {
  type = string
}

variable "vite_client_secret" {
  type = string
}

variable "vite_cognito_code_endpoint" {
  type = string
}

variable "vite_cognito_token_endpoint" {
  type = string
}

variable "vite_redirect_uri" {
  type = string
}
