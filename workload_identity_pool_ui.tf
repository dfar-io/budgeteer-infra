resource "google_storage_bucket_iam_member" "storage_access_ui" {
  # need to use state bucket in different project
  bucket = google_storage_bucket.static-site.name
  role   = "roles/storage.legacyBucketOwner"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/dfar-io/budgeteer-ui"
}

resource "github_actions_secret" "workload_identity_pool_provider_name_budgeteer_ui" {
  repository       = "budgeteer-ui"
  secret_name      = "WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value  = google_iam_workload_identity_pool_provider.github_actions.name
}