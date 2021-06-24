resource "google_active_directory_domain" "ads" {
  domain_name       = var.ad_domain
  locations         = [var.location]
  reserved_ip_range = var.cidr_rd_ad
  admin         = var.ad_username
  authorized_networks = [google_compute_network.vpc.id]
}