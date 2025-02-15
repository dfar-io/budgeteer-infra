resource "google_cloud_run_v2_service" "ui" {
  name     = "ui"
  project  = google_project.project.project_id
  location = local.location

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }

  depends_on = [google_project_service.cloud_run_admin]
}

resource "google_cloud_run_domain_mapping" "ui" {
  location = local.location
  project  = google_project.project.project_id
  name     = "bc.dfar.io"

  metadata {
    namespace = google_project.project.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.ui.name
  }
}

data "google_iam_policy" "all_users" {
  binding {
    role = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "public" {
    location = local.location
    project  = google_project.project.project_id
    service  = google_cloud_run_v2_service.ui.name

    policy_data = data.google_iam_policy.all_users.policy_data
}

resource "google_project_service" "cloud_run_admin" {
  project = google_project.project.project_id
  service = "run.googleapis.com"
}