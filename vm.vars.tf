variable "vm_deployment_region" {
  default     = "europe-central2-a"
  type        = string
  description = "region for the vm deployment"
}

variable "vm_size" {
  default     = "e2-micro"
  type        = string
  description = "size of the VM instance"
  validation {
    condition     = var.vm_size == "e2-micro" || var.vm_size == "e2-small"
    error_message = "The vm_size must be either 'e2-micro' or 'e2-small' for the cost optimization."
  }
}

variable "vm_nic_type_gvnic" {
  default = "GVNIC"
  type    = string
}

variable "vm_nic_type" {
  default     = "GVNIC"
  description = "The type of vNIC to be used on this interface. Possible values: GVNIC, VIRTIO_NET"
  type        = string
  validation {
    condition     = var.vm_nic_type == "GVNIC" || var.vm_nic_type == "VIRTIO_NET"
    error_message = "The vm_nic_type must be either 'GVNIC' or 'VIRTIO_NET'."
  }
}

variable "vm_enable_secure_boot" {
  type        = bool
  default     = true
  description = "Whether secure boot is enabled for the instance."
}

variable "vm_image" {
  default     = "debian-cloud/debian-12"
  type        = string
  description = "image for the VM provisioning"
}

variable "vm_provisioning_model_spot" {
  default = "SPOT"
  type    = string
}

variable "vm_provisioning_model" {
  description = "The provisioning model for the instance (SPOT or STANDARD)"
  type        = string
  default     = "SPOT"
  validation {
    condition     = var.vm_provisioning_model == "SPOT" || var.vm_provisioning_model == "STANDARD"
    error_message = "The vm_provisioning_model must be either 'SPOT' or 'STANDARD'."
  }
}

variable "vm_instance_termination_action" {
  default     = "STOP"
  type        = string
  description = "Specifies the action GCE should take when SPOT VM is preempted."
  validation {
    condition     = var.vm_instance_termination_action == "STOP" || var.vm_instance_termination_action == "DELETE"
    error_message = "The vm_instance_termination_action must be either 'STOP' or 'DELETE'."
  }
}

variable "vm_cloud_init_file_name" {
  default     = "cloud-init.sh"
  description = "name of the script executed after the VM provisioning"
  type        = string
}

variable "vm_ssh_username" {
  default     = "adam"
  description = "name of the user used for the SSH connection, correlated with the one within the pub key"
  type        = string
}
