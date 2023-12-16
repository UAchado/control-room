variable "google_api_key" {
  type        = string
  description = "The Google API key"
}

variable "vite_client_id" {
  type = string
  description = "Cognito client ID"
}

variable "vite_client_secret" {
  type = string
  description = "Cognito client secret"
}

variable "vite_cognito_code_endpoint" {
  type = string
  description = "Cognito code endpoint"
}

variable "vite_cognito_token_endpoint" {
  type = string
  description = "Cognito token endpoint"
}

variable "vite_redirect_uri" {
  type = string
  description = "Cognito redirect URI"
}
