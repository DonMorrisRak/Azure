resource "google_compute_network" "vpc" {
  project                 = var.project_id # Replace this with your project ID in quotes
  name                    = "vpc-rds"
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "rds-gw" {
  project                 = var.project_id
  name          = "rds-gw-web"
  ip_cidr_range = var.cidr_rd_web
  region        = var.location
  network       = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "rds-cb" {
  project                 = var.project_id
  name          = "rds-cb-ls"
  ip_cidr_range = var.cidr_rd_cb
  region        = var.location
  network       = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "rds-sh" {
  project                 = var.project_id
  name          = "rds-sh"
  ip_cidr_range = var.cidr_rd_sh
  region        = var.location
  network       = google_compute_network.vpc.id
  private_ip_google_access = true
}
resource "google_compute_firewall" "rules" {
  project     = var.project_id
  name        = "internal"
  network     = google_compute_network.vpc.id
  description = "Creates firewall rule targeting tagged instances"
  direction   = "INGRESS"
  priority    = "100"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
      protocol = "icmp"
  }

  source_ranges = ["10.100.4.0/23"]
}

resource "google_compute_firewall" "remote" {
  project     = var.project_id
  name        = "remote"
  network     = google_compute_network.vpc.id
  direction   = "INGRESS"
  priority    = "110"

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

    source_ranges = ["35.235.240.0/20"]
}