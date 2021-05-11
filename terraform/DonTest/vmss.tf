resource "azurerm_windows_virtual_machine_scale_set" "sf" {
  name                 = "ukststfosvmss"
  computer_name_prefix = "ukststfos"
  resource_group_name  = azurerm_resource_group.sf.name
  location             = azurerm_resource_group.sf.location
  sku                  = "Standard_D2_v3"
  instances            = azurerm_service_fabric_cluster.sf.node_type[0].instance_count
  admin_password       = "P@55w0rd1234!"
  admin_username       = "adminuser"
  overprovision        = false
  upgrade_mode         = "Automatic"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.sf.id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.sf.id
      ]
      load_balancer_inbound_nat_rules_ids = [
        azurerm_lb_nat_pool.sf.id
      ]
    }
  }

  secret {
  certificate {
      store = "My"
      url   = "https://don-sf-kv.vault.azure.net/secrets/fab/ec905bfa849c448a97066ed0d643f16b"
    }
    key_vault_id = data.azurerm_key_vault.sf.id
  }

  extension {
    name                       = "sfServiceFabricNode"
    publisher                  = "Microsoft.Azure.ServiceFabric"
    type                       = "ServiceFabricNode"
    type_handler_version       = "1.1"
    auto_upgrade_minor_version = false

    settings = jsonencode({
      "clusterEndpoint"    = azurerm_service_fabric_cluster.sf.cluster_endpoint
      "nodeTypeRef"        = azurerm_service_fabric_cluster.sf.node_type[0].name
      "durabilityLevel"    = "bronze"
      "nicPrefixOverride"  = azurerm_subnet.sf.address_prefixes[0]
      "enableParallelJobs" = true
      "certificate" = {
        "commonNames" = ["fab.local"]
        "x509StoreName" = "My"
      }
    })

    protected_settings = jsonencode({
      "StorageAccountKey1" = azurerm_storage_account.sf.primary_access_key
      "StorageAccountKey2" = azurerm_storage_account.sf.secondary_access_key
    })
  }

}