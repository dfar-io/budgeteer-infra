locals {
  project_id = google_project.project.project_id
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
  org_id     = local.org_id
  # Allows Terraform to delete this project
  deletion_policy = "DELETE"
  # Allow billing using default billing account
  billing_account = data.google_billing_account.acct.id
}

resource github_actions_secret ui_project_id {
  repository       = "budgeteer-ui"
  secret_name      = "PROJECT_ID"
  plaintext_value  = google_project.project.project_id
}

resource github_dependabot_secret ui_project_id {
  repository       = "budgeteer-ui"
  secret_name      = "PROJECT_ID"
  plaintext_value  = google_project.project.project_id
}
