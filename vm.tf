
resource "google_compute_instance" "default" {
  name         = "${var.project_name}-instance"
  machine_type = var.vm_size
  zone         = var.vm_deployment_region

  boot_disk {
    device_name = "${var.project_name}-disk"
    initialize_params {
      image = var.vm_image
    }
  }
  metadata_startup_script = templatefile(var.vm_cloud_init_file_name, {
    key_json_base64 = filebase64(var.service_account_file_name)
    ssh_username    = var.vm_ssh_username
  })

  metadata = {
    ssh-keys = "${var.vm_ssh_username}:${data.google_secret_manager_secret_version.latest.secret_data}"
  }

  scheduling {
    provisioning_model          = var.vm_provisioning_model
    preemptible                 = var.vm_provisioning_model == var.vm_provisioning_model_spot ? true : false
    automatic_restart           = var.vm_provisioning_model == var.vm_provisioning_model_spot ? false : true
    instance_termination_action = var.vm_instance_termination_action
  }

  network_interface {
    nic_type = var.vm_nic_type
    network  = var.network_name
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  enable_display = var.vm_nic_type == var.vm_nic_type_gvnic ? true : false
  shielded_instance_config {
    enable_secure_boot = var.vm_enable_secure_boot
  }
  tags = var.default_tags
}
