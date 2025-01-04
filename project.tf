data "google_billing_account" "acct" {
  display_name = "My Billing Account"
  open         = true
}

resource "random_string" "project-prefix" {
  length = 5
  special = false
  upper   = false
}

resource "google_project" "project" {
  name       = "budgeteer"
  project_id = "budgeteer-${random_string.project-prefix.result}"
  # Use organization provided when creating GCP org.
  org_id     = 174756564188
  # Allows Terraform to delete this project
  deletion_policy = "DELETE"
  # Allow billing using default billing account
  billing_account = data.google_billing_account.acct.id
}
