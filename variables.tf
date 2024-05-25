variable "okta_org_name" {
  description = "The name of your Okta organization."
  type        = string
}

variable "okta_base_url" {
  description = "The base URL for your Okta organization."
  type        = string
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "The API token for your Okta organization."
  type        = string
  sensitive   = true
}
