resource "azurerm_service_fabric_cluster" "sf" {
  name                = "ukststfosfab01"
  resource_group_name = azurerm_resource_group.sf.name
  location            = azurerm_resource_group.sf.location
  reliability_level   = "None"
  upgrade_mode        = "Manual"
  vm_image            = "Windows"
  #management_endpoint = "https://donsftestservicefabric.${var.location}.cloudapp.azure.com:80"
  management_endpoint = "https://${azurerm_lb.sf.frontend_ip_configuration[0].private_ip_address}:19080"

  add_on_features = ["DnsService", "RepairManager"]

  diagnostics_config {
      storage_account_name = azurerm_storage_account.sf.name
      protected_account_key_name = "StorageAccountKey1"
      blob_endpoint = azurerm_storage_account.sf.primary_blob_endpoint
      queue_endpoint = azurerm_storage_account.sf.primary_queue_endpoint
      table_endpoint = azurerm_storage_account.sf.primary_table_endpoint
  }

  node_type {
    name                 = "ukststfosnode"
    instance_count       = 1
    is_primary           = true
    client_endpoint_port = 19000
    http_endpoint_port   = 19080
    reverse_proxy_endpoint_port = 19081
    application_ports {
      start_port = 20001
      end_port   = 29000
    }
    ephemeral_ports {
      start_port = 49152
      end_port   = 65535
    }    
  }
  reverse_proxy_certificate {
    thumbprint      = "49AD8708672DC60EF3CBF7E4AAE87FDDDF3D35A4"
    x509_store_name = "My"
  }

  certificate {
    thumbprint      = "49AD8708672DC60EF3CBF7E4AAE87FDDDF3D35A4"
    x509_store_name = "My"
  }

  client_certificate_thumbprint {
    thumbprint = "49AD8708672DC60EF3CBF7E4AAE87FDDDF3D35A4"
    is_admin   = true
  }


}