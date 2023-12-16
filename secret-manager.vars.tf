variable "secret_manager_ssh_key_secret_id" {
  default     = "ssh-pub-key"
  type        = string
  description = "This must be unique within the project."
}

variable "ssh_key_name" {
  default     = "google-vm.pub"
  type        = string
  description = "file name of the pub ssh key"
}

variable "secret_manager_secret_version" {
  default     = "latest"
  type        = string
  description = "version of the taken secret from the secret manager"
}