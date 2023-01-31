variable "project_id" {
  type = string
  default = "mean-stack-on-serverless"
}

provider "google" {
    project = "mean-stack-on-serverless"
}

module "artifact_registry_frontend" {
  source = "./modules/artifact_registry"
  project_id = var.project_id
  repository_id = "frontend"
}

module "artifact_registry_backend" {
  source = "./modules/artifact_registry"
  project_id = var.project_id
  repository_id = "backend"
}