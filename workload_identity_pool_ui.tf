locals {
  ui_principal = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/dfar-io/budgeteer-ui"
  service_account = "serviceAccount:${google_service_account.github.email}"
}

resource google_project_iam_member ui_service_account_token_creator {
  project = google_project.project.project_id
  role   = "roles/iam.serviceAccountTokenCreator"
  member = local.ui_principal
}

# deploy Cloud Run
resource google_project_iam_member ui_service_account_user {
  project = google_project.project.project_id
  role   = "roles/iam.serviceAccountUser"
  member = local.service_account
}
resource google_project_iam_member ui_run_admin {
  project = google_project.project.project_id
  role   = "roles/run.admin"
  member = local.service_account
}
resource google_project_iam_member ui_cloudbuild_builds_editor {
  project = google_project.project.project_id
  role   = "roles/cloudbuild.builds.editor"
  member = local.service_account
}
resource google_project_iam_member ui_storage_admin {
  project = google_project.project.project_id
  role   = "roles/storage.admin"
  member = local.service_account
}
resource google_project_iam_member ui_artifact_registry_admin {
  project = google_project.project.project_id
  role   = "roles/artifactregistry.admin"
  member = local.service_account
}

resource "github_actions_secret" "workload_identity_pool_provider_name_budgeteer_ui" {
  repository       = "budgeteer-ui"
  secret_name      = "WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value  = google_iam_workload_identity_pool_provider.github_actions.name
}

resource github_actions_secret ui_project_id {
  repository       = "budgeteer-ui"
  secret_name      = "PROJECT_ID"
  plaintext_value  = google_project.project.project_id
}
