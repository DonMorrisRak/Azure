resource "google_compute_disk" "rds_cb_ls" {
  name  = "rds-cb-ls-boot"
  zone  = var.zone
  image = "windows-2019"
  size  = 60
  type  = "pd-balanced"

  physical_block_size_bytes = 4096
}

resource "google_compute_instance" "rds_cb_ls" {
  name                      = "uksrdscbls1"
  machine_type              = "e2-small"
  zone                      = var.zone
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = "true"
    source      = google_compute_disk.rds_cb_ls.self_link
  }

  network_interface {
    subnetwork         = data.google_compute_subnetwork.rds-cb.self_link
  }

metadata = {
    windows-startup-script-url	= "gs://don-rax-rds/startup.ps1"
#     sysprep-specialize-script-url  = "gs://rs-gce-instances-scripts-master/windows/rs-config.ps1"
#     configure-windows-rdp          = true
#     configure-windows-rm           = true
#     install-stackdriver-monitoring = true
#     install-stackdriver-logging    = true
#     configure-windows-update       = true
#     windows-update-type            = true
#     configure-windows-firewall     = true
#     windows-firewall-enabled       = false
#     initialise-gcp-disks           = true
}

  service_account {
    email  = "don-157@mpc-donavan-morris.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}