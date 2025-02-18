resource google_artifact_registry_repository repo {
  project       = local.project_id
  location      = local.location
  repository_id = "repo"
  format        = "DOCKER"

  depends_on = [google_project_service.artifactregistry]
}

resource google_project_service artifactregistry {
  project = google_project.project.project_id
  service = "artifactregistry.googleapis.com"
}