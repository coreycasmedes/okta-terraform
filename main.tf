resource "okta_app_oauth" "example" {
  label             = "Example App"
  type              = "browser"
  grant_types       = ["authorization_code"]
  response_types    = ["code"]
  redirect_uris     = ["https://example.com/oauth/callback"]
  login_uri         = "https://example.com/login"
  enduser_note      = "Example App for OAuth2"
  client_uri        = "https://example.com"
  logo_uri          = "https://example.com/logo.png"
  tos_uri           = "https://example.com/tos"
  policy_uri        = "https://example.com/policy"

  omit_secret       = false
  auto_key_rotation = true
}