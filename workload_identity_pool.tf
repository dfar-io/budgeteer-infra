# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool
# https://andrekoenig.de/articles/workload-identity-federation-for-secure-access-to-google-cloud-platform-via-github-actions
# used for Github Actions and CICD

resource "random_string" "pool_name" {
  length = 5
  special = false
  upper   = false
}

# Need to apply a delay to prevent:
#   Error creating WorkloadIdentityPool: googleapi: Error 403:
#   Permission 'iam.workloadIdentityPools.create' denied on resource
#   '//iam.googleapis.com/projects/budgeteer-wa3rj/locations/global' (or it may not exist).
resource "null_resource" "before" {
  depends_on = [google_project.project]
}
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 90"
  }
  triggers = {
    "before" = null_resource.before.id
  }
}
resource "null_resource" "after" {
  depends_on = [null_resource.delay]
}

resource "google_iam_workload_identity_pool" "github_actions" {
  project = google_project.project.project_id
  workload_identity_pool_id = "github-actions-${random_string.pool_name.id}"

  depends_on = [null_resource.after]
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  project = google_project.project.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  attribute_mapping                  = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  attribute_condition = "assertion.repository_owner == 'dfar-io'"
  oidc {
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}

resource "google_storage_bucket_iam_member" "storage_access_budgeteer" {
  bucket = google_storage_bucket.static-site.name
  role   = "roles/storage.objectUser"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/dfar-io/budgeteer-infra"
}

resource "google_storage_bucket_iam_member" "storage_access_budgeteer-infra" {
  # need to use state bucket in different project
  bucket = "budgeteer-tf-state"
  role   = "roles/storage.objectUser"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/dfar-io/budgeteer-infra"
}

resource "github_actions_secret" "workload_identity_pool_provider_name_budgeteer" {
  repository       = "budgeteer"
  secret_name      = "WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value  = google_iam_workload_identity_pool_provider.github_actions.name
}

resource "github_actions_secret" "workload_identity_pool_provider_name_budgeteer_infra" {
  repository       = "budgeteer-infra"
  secret_name      = "WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value  = google_iam_workload_identity_pool_provider.github_actions.name
}

# prefer this but I get
# Error: GET https://api.github.com/orgs/dfar-io/actions/secrets/public-key: 404 Not Found []
#
# resource "github_actions_organization_secret" "workload_identity_pool_provider_name" {
#   secret_name      = "WORKLOAD_IDENTITY_PROVIDER"
#   visibility       = "all"
#   plaintext_value  = google_iam_workload_identity_pool_provider.github_actions.name
# }
