# resource "okta_auth_server" "openmetadata_authorization_server" {
#   audiences   = ["api://example"]
#   description = "My Example Auth Server"
#   name        = "example"
#   issuer_mode = "CUSTOM_URL"
#   status      = "ACTIVE"
# }

resource "okta_app_oauth" "openmetadata_app" {
  label             = "Open Metadata test"
  type              = "browser" # For SPA apps use browser
  grant_types       = ["authorization_code", "refresh_token", "implicit"]
  response_types    = ["code", "token"]
  redirect_uris     = ["https://localhost:443/callback", "https://localhost:443/silent-callback"]
  login_uri         = "https://example.com/login"
  enduser_note      = "Example App for OAuth2"
  client_uri        = "https://example.com"
  token_endpoint_auth_method = "none"
  pkce_required = true
#   logo_uri          = "https://example.com/logo.png"
#   tos_uri           = "https://example.com/tos"
#   policy_uri        = "https://example.com/policy"

  omit_secret       = true
  auto_key_rotation = true
  
}

resource "okta_auth_server" "openmetadata_auth_server" {
    name = "Open Metadata Authorization Server"
    audiences = [okta_app_oauth.openmetadata_app.client_id]
    issuer_mode = "ORG_URL"
    depends_on = [ okta_app_oauth.openmetadata_app ]
}

resource "okta_auth_server_scope" "openmetadata_scope" {
    name = "openmetadata"
    auth_server_id = okta_auth_server.openmetadata_auth_server.id
    consent = "IMPLICIT"
    default = true
}


resource "okta_auth_server_claim_default" "openmetadata_claim_sub" {
    auth_server_id = okta_auth_server.openmetadata_auth_server.id
    name = "sub"
    value = "(appuser != null) ? appuser.userName : app.clientId"
    
    depends_on = [ okta_auth_server.openmetadata_auth_server ]
}

resource "okta_auth_server_claim" "openmetadata_claim_email" {
    auth_server_id = okta_auth_server.openmetadata_auth_server.id
    name = "email"
    value = "appuser.email"
    claim_type = "RESOURCE"
    
    depends_on = [ okta_auth_server.openmetadata_auth_server ]
}

resource "okta_auth_server_claim" "openmetadata_claim_preferred_username" {
    auth_server_id = okta_auth_server.openmetadata_auth_server.id
    name = "preferred_username"
    value = "(appuser.preferred_username != null) ? appuser.preferred_username : appuser.login"
    claim_type = "RESOURCE"
    
    depends_on = [ okta_auth_server.openmetadata_auth_server ]
}

resource "okta_auth_server_policy" "openmetadata_auth_server_policy" {
    name = "openmetadata_access_policy"
    description = "Access Policy for Open Metadata Authorization Server"
    auth_server_id = okta_auth_server.openmetadata_auth_server.id
    client_whitelist = ["ALL_CLIENTS"]
    priority = 1
    depends_on = [ okta_auth_server.openmetadata_auth_server ]
}

resource "okta_auth_server_policy_rule" "openmetdata_auth_server_policy_rule" {
    name = "openmetadata_access_policy_rule"
    auth_server_id = okta_auth_server.openmetadata_auth_server.id
    policy_id = okta_auth_server_policy.openmetadata_auth_server_policy.id
    priority = 1
    grant_type_whitelist = [ "client_credentials", "authorization_code" ]
    scope_whitelist = ["*"]
    user_whitelist = [  ]
}


