data "google_compute_network" "vpc" {
  name = "vpc-rds"
  project                 = var.project_id
}

data "google_compute_subnetwork" "rds-gw" {
  name          = "rds-gw-web"
  project                 = var.project_id
}

data "google_compute_subnetwork" "rds-sh" {
  name          = "rds-sh"
  project                 = var.project_id
}

data "google_compute_subnetwork" "rds-cb" {
  name          = "rds-cb-ls"
  project                 = var.project_id
}

