# resource "google_compute_http_health_check" "default" {
#     project     = var.project_id
#   name               = "default"
#   request_path       = "/"
#   check_interval_sec = 60
#   timeout_sec        = 60
# }

# resource "google_compute_target_pool" "default" {
#   project     = var.project_id
#   name = "rds-pool"

#   instances = [
#     google_compute_instance.rds_gw_web.self_link,
#   ]

#   health_checks = [
#     google_compute_http_health_check.default.name
#   ]
# }

# resource "google_compute_forwarding_rule" "http" {
#   project     = var.project_id
#   name       = "rds-http"
#   target     = google_compute_target_pool.default.self_link
#   port_range = "80"
#   ip_address = data.google_compute_address.ip.address
#   load_balancing_scheme = "EXTERNAL"
# }

# resource "google_compute_forwarding_rule" "https" {
#   project     = var.project_id
#   name       = "rds-https"
#   target     = google_compute_target_pool.default.self_link
#   port_range = "443"
#   ip_address = data.google_compute_address.ip.address
#   load_balancing_scheme = "EXTERNAL"
# }

# resource "google_compute_forwarding_rule" "rds" {
#   project     = var.project_id
#   name       = "rds-rds"
#   target     = google_compute_target_pool.default.self_link
#   port_range = "3389"
#   ip_address = data.google_compute_address.ip.address
#   load_balancing_scheme = "EXTERNAL"
# }

# resource "google_compute_forwarding_rule" "rd2" {
#   project     = var.project_id
#   name       = "rds-rd2"
#   target     = google_compute_target_pool.default.self_link
#   port_range = "3391"
#   ip_address = data.google_compute_address.ip.address
#   load_balancing_scheme = "EXTERNAL"
# }