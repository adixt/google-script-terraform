variable "project_name" {
  type        = string
  default     = "fir-withnextjs"
  description = "name of the Google Cloud Project for the deployment"
}

variable "service_account_file_name" {
  type        = string
  default     = "key.json"
  description = "name of the service_account auth file"
}

variable "deployment_region" {
  default     = "europe-central2"
  type        = string
  description = "region for the deployment"
}

variable "default_tags" {
  type        = list(string)
  default     = ["terraform-instance-tag"]
  description = "description tags for the resources"
}

