# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket

resource "google_storage_bucket" "static-site" {
  project       = google_project.project.project_id
  name          = "b.dfar.io"
  location      = "us-east4" # why doesn't this use the provider default?
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}

resource "google_storage_bucket_iam_binding" "public_read_access" {
  bucket = google_storage_bucket.static-site.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}