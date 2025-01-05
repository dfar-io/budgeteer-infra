locals {
  infra_principal = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/dfar-io/budgeteer-infra"
}

resource "google_storage_bucket_iam_member" "storage_access_infra" {
  # need to use state bucket in different project
  bucket = "budgeteer-tf-state"
  role   = "roles/storage.legacyBucketOwner"
  member = local.infra_principal
}

# probably only need viewer for this
resource "google_organization_iam_member" "viewer_infra" {
  org_id  = local.org_id
  role    = "roles/viewer"
  member  = local.infra_principal
}
resource "google_organization_iam_member" "billing_viewer_infra" {
  org_id  = local.org_id
  role    = "roles/billing.viewer"
  member  = local.infra_principal
}

resource "google_project_iam_member" "viewer_infra" {
  project = google_project.project.project_id
  role    = "roles/viewer"
  member  = local.infra_principal
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