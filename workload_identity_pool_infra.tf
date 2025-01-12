locals {
  infra_principal = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/dfar-io/budgeteer-infra"
}

resource "google_storage_bucket_iam_member" "storage_access_infra" {
  # need to use state bucket in different project
  bucket = "budgeteer-tf-state"
  role   = "roles/storage.legacyBucketOwner"
  member = local.infra_principal
}

# try using editor to access org IAM info
resource "google_organization_iam_member" "editor_infra" {
  org_id  = local.org_id
  role    = "roles/editor"
  member  = local.infra_principal
}
resource "google_organization_iam_member" "billing_viewer_infra" {
  org_id  = local.org_id
  role    = "roles/billing.viewer"
  member  = local.infra_principal
}
# Need this for IAN roles in organization
resource "google_organization_iam_member" "security_reviewer_infra" {
  org_id  = local.org_id
  role    = "roles/iam.securityReviewer"
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
