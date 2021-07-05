resource "google_compute_address" "ip" {
  project     = var.project_id
  name    = "rds-gw-pip"
  address_type  = "EXTERNAL"
}