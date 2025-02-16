locals {
  infra_principal = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/dfar-io/budgeteer-infra"
  github_sa = "serviceAccount:${google_service_account.github_sa.email}"
}

resource "google_storage_bucket_iam_member" "storage_access_infra" {
  # need to use state bucket in different project
  bucket = "budgeteer-tf-state"
  role   = "roles/storage.legacyBucketOwner"
  member = local.github_sa
}

# try using editor to access org IAM info
resource "google_organization_iam_member" "editor_infra" {
  org_id  = local.org_id
  role    = "roles/editor"
  member  = local.github_sa
}
resource "google_organization_iam_member" "billing_viewer_infra" {
  org_id  = local.org_id
  role    = "roles/billing.viewer"
  member  = local.github_sa
}
# Need this to view IAM roles for organization
# https://github.com/terraform-google-modules/terraform-example-foundation/issues/558
resource "google_organization_iam_member" "security_reviewer_infra" {
  org_id  = local.org_id
  role    = "roles/iam.securityReviewer"
  member  = local.github_sa
}

resource "google_project_service" "billing" {
  project = google_project.project.project_id
  service = "cloudbilling.googleapis.com"
}

resource "google_project_service" "resource_manager" {
  project = google_project.project.project_id
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "service_usage" {
  project = google_project.project.project_id
  service = "serviceusage.googleapis.com"
}

resource "google_project_service" "iam" {
  project = google_project.project.project_id
  service = "iam.googleapis.com"
}

resource "github_actions_secret" "workload_identity_pool_provider_name_budgeteer_infra" {
  repository       = "budgeteer-infra"
  secret_name      = "WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value  = google_iam_workload_identity_pool_provider.github_actions.name
}

resource "github_actions_secret" "github_sa_budgeteer_infra" {
  repository       = "budgeteer-infra"
  secret_name      = "GH_SERVICE_ACCOUNT"
  plaintext_value  = google_service_account.github_sa.name
}
