variable "project-id" {
  type = string
  default = "mean-stack-on-serverless"
}

provider "google" {
    project = "mean-stack-on-serverless"
}

resource "google_artifact_registry_repository" "frontend" {
  provider = google-beta

  project = var.project-id
  location = "us-central1"
  repository_id = "frontend"
  format = "Docker"
}

resource "google_artifact_registry_repository" "backend" {
  provider = google-beta

  project = var.project-id
  location = "us-central1"
  repository_id = "backend"
  format = "Docker"
}