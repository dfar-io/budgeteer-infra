resource google_service_account github {
  project    = google_project.project.project_id
  account_id = "github"
}

resource github_actions_secret service_account_budgeteer_ui {
  repository      = "budgeteer-ui"
  secret_name     = "SERVICE_ACCOUNT"
  plaintext_value = google_service_account.github.email
}
