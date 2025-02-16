# needed to manually accept TOS first
# 
# https://stackoverflow.com/a/79345435

resource "google_firebase_project" "default" {
  provider = google-beta
  project  = google_project.project.project_id
  
  depends_on = [
    google_project_service.firebase,
    google_project_service.cloudapis
  ]
}

resource "google_project_service" "firebase" {
  project = google_project.project.project_id
  service = "firebase.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "firebasehosting" {
  project = google_project.project.project_id
  service = "firebasehosting.googleapis.com"
}

resource "google_project_service" "cloudapis" {
  project = google_project.project.project_id
  service = "cloudapis.googleapis.com"
}