locals {
  infra_principal = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/dfar-io/budgeteer-infra"
}

resource "google_storage_bucket_iam_member" "storage_access_infra" {
  # need to use state bucket in different project
  bucket = "budgeteer-tf-state"
  role   = "roles/storage.objectUser"
  member = local.infra_principal
}

resource "google_project_iam_member" "viewer_infra" {
  project = google_project.project.project_id
  role    = "roles/viewer"
  member  = local.infra_principal
}
