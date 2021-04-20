resource "azurerm_service_fabric_cluster" "sf" {
  name                = "donsftest"
  resource_group_name = azurerm_resource_group.sf.name
  location            = azurerm_resource_group.sf.location
  reliability_level   = "None"
  upgrade_mode        = "Manual"
  vm_image            = "Windows"
  #management_endpoint = "https://donsftestservicefabric.${var.location}.cloudapp.azure.com:80"
  management_endpoint = "https://${azurerm_lb.sf.frontend_ip_configuration[0].private_ip_address}:80"

  node_type {
    name                 = "Windows"
    instance_count       = 1
    is_primary           = true
    client_endpoint_port = 8080
    http_endpoint_port   = 80
    application_ports {
      start_port         = 20050
      end_port           = 20500 
    }
  }
  reverse_proxy_certificate {
    thumbprint      = azurerm_key_vault_certificate.sf.thumbprint
    x509_store_name = "My"
  }

  certificate {
    thumbprint      = azurerm_key_vault_certificate.sf.thumbprint
    x509_store_name = "My"
  }

  client_certificate_thumbprint {
    thumbprint = azurerm_key_vault_certificate.sf.thumbprint
    is_admin   = true
  }
}