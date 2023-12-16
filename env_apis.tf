variable "smtp_server" {
  type        = string
  description = "The SMTP server"
}

variable "smtp_port" {
  type        = string
  description = "The SMTP port"
}

variable "email_username" {
  type        = string
  description = "The SMTP username"
}

variable "email_password" {
  type        = string
  description = "The SMTP password"
  sensitive   = true
}

variable "cognito_issuer" {
  type        = string
  description = "The Cognito issuer"
}

variable "cognito_audience" {
  type        = string
  description = "The Cognito audience"
}