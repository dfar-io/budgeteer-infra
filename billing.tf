# Reference to central billing account
data "google_billing_account" "acct" {
  display_name = "My Billing Account"
  open         = true
}