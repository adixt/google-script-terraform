resource "google_secret_manager_secret" "ssh_key" {
  secret_id = var.secret_manager_ssh_key_secret_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "version" {
  secret      = google_secret_manager_secret.ssh_key.id
  secret_data = file(var.ssh_key_name)
}
