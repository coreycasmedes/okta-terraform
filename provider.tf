terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.8.1"
    }
  }
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}


