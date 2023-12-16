resource "google_compute_firewall" "open_ports" {
  name    = "${var.project_name}-firewall"
  network = var.network_name

  allow {
    protocol = var.network_opened_ports_type
    ports    = var.network_opened_ports
  }

  source_ranges = var.network_allowed_ip_source_ranges
  target_tags   = var.default_tags
}

resource "google_compute_address" "static_ip" {
  name = "${var.project_name}-ip"
}
