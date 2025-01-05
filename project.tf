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

resource "github_actions_secret" "gcp_project_id_budgeteer" {
  repository       = "budgeteer"
  secret_name      = "GCP_PROJECT_ID"
  plaintext_value  = google_project.project.project_id
}

resource "github_actions_secret" "gcp_project_id_budgeteer_infra" {
  repository       = "budgeteer-infra"
  secret_name      = "GCP_PROJECT_ID"
  plaintext_value  = google_project.project.project_id
}

resource "google_project_service" "billing" {
  project = google_project.project.project_id
  service = "cloudbilling.googleapis.com"
}