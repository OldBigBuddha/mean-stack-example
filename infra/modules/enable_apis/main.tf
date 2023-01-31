variable "gcp_service_list" {
  type = list(string)

  # TODO: これで十分か確認する
  default = [
    "cloudbuild.googleapis.com",
    "containerregistry.googleapis.com", # TODO: Artifact Register
    "run.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

resource "google_project_service" "activate_gcp_services" {
  for_each = toset(var.gcp_service_list)
  service  = each.key
}