provider "google" {
  credentials = file(var.service_account_file_name)
  project     = var.project_name
  region      = var.deployment_region
}
