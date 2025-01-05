locals {
  infra_principal = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/dfar-io/budgeteer-infra"
}

resource "google_storage_bucket_iam_member" "storage_access_infra" {
  # need to use state bucket in different project
  bucket = "budgeteer-tf-state"
  role   = "roles/storage.objectUser"
  member = local.infra_principal
}

resource "google_billing_account_iam_member" "billing_access_infra" {
  # use central billing acct
  billing_account_id = data.google_billing_account.acct.id
  role    = "roles/billing.user"
  member  = local.infra_principal
}