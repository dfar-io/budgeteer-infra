resource "google_cloud_run_v2_service" "ui" {
  name     = "ui"
  project  = google_project.project.project_id
  location = local.location
  // allow for seamless destroy/apply
  deletion_protection = false

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }

  depends_on = [google_project_service.cloud_run_admin]
}

resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloud_run_v2_service.ui.location
  project  = google_cloud_run_v2_service.ui.project
  service  = google_cloud_run_v2_service.ui.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_project_service" "cloud_run_admin" {
  project = google_project.project.project_id
  service = "run.googleapis.com"
}