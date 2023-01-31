resource "google_project_iam_member" "cloudbuild_iam" {
  for_each = toset([
    "roles/run.developer",
    "roles/iam.serviceAccountUser"
  ])
  role    = each.key

  project = var.project_id
  member  = "serviceAccount:${var.service_account_email}"
}

resource "google_cloudbuild_trigger" "cloudbuild_triggger" {
  # no specified location because it's global
  name     = var.name
  filename = var.file_name

  github {
    owner = var.github_owner
    name  = var.github_repository
    push {
      branch = "^main$"
    }
  }
}