# Reference to central billing account
data "google_billing_account" "acct" {
  display_name = "My Billing Account"
  open         = true
}

locals {
    org_id = 174756564188
}