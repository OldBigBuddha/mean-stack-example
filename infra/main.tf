variable "project_id" {
  type = string
  default = "mean-stack-on-serverless"
}

variable "location" {
  type = string
  default = "us-central1"
}

provider "google" {
    project = "mean-stack-on-serverless"
}

module "cloud_run_service_account" {
  source = "./modules/service_account"
  account_id = "cloudrun"
  display_name = "Cloud Run Service Account"
}

module "artifact_registry_frontend" {
  source = "./modules/artifact_registry"
  project_id = var.project_id
  repository_id = "frontend-tf"
}

module "artifact_registry_backend" {
  source = "./modules/artifact_registry"
  project_id = var.project_id
  repository_id = "backend-tf"
}

module "cloud_build_frontend" {
  source = "./modules/cloud_build"
  depends_on = [
    module.cloud_run_service_account,
    module.artifact_registry_frontend
  ]

  project_id = var.project_id
  name = "frontend-tf"
  file_name = "client/cloudbuild.yaml"
  service_account_email = module.cloud_run_service_account.email
  github_owner = "OldBigBuddha"
  github_repository = "mean-stack-example"
}

module "cloud_build_backend" {
  source = "./modules/cloud_build"
  depends_on = [
    module.cloud_run_service_account,
    module.artifact_registry_backend
  ]

  project_id = var.project_id
  name = "backend-tf"
  file_name = "server/cloudbuild.yaml"
  service_account_email = module.cloud_run_service_account.email
  github_owner = "OldBigBuddha"
  github_repository = "mean-stack-example"
}

module "cloud_run_frontend" {
  source = "./modules/cloud_run"
  depends_on = [
    module.cloud_run_service_account,
    module.artifact_registry_frontend
  ]

  project_id = var.project_id
  name = "frontend-tf"
  service_account_email = module.cloud_run_service_account.email
  app_name = "angular-web-app"
  repository_id = module.artifact_registry_frontend.repository_name
}

module "cloud_run_backend" {
  source = "./modules/cloud_run"
  depends_on = [
    module.cloud_run_service_account,
    module.artifact_registry_backend
  ]

  project_id = var.project_id
  name = "backend-tf"
  service_account_email = module.cloud_run_service_account.email
  app_name = "node-express-api"
  repository_id = module.artifact_registry_backend.repository_name
}