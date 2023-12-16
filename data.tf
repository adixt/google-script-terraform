data "google_secret_manager_secret_version" "latest" {
  secret  = google_secret_manager_secret.ssh_key.id
  version = var.secret_manager_secret_version
  depends_on = [ google_secret_manager_secret_version.version ]
}
