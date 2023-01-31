variable "project_id" {
  type = string
}

variable "location" {
  type = string
  default = "us-central1"
}

variable "repository_id" {
  type = string
}

resource "google_artifact_registry_repository" "repository" {
  provider = google-beta

  project = var.project_id
  location = var.location
  repository_id = var.repository_id
  format = "Docker"
}
