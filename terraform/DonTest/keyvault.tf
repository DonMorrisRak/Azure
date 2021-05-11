# resource "azurerm_key_vault" "sf" {
#   name                        = "don-sf-lv"
#   location                    = "UK South"
#   resource_group_name         = "DON-VNET"
#   enabled_for_disk_encryption = true
#   enabled_for_deployment      = true
#   tenant_id                   = "cc59b7cf-e696-48da-b102-b44d574f39b2"
#   purge_protection_enabled    = false

#   sku_name = "standard"

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     certificate_permissions = [
#       "create",
#       "delete",
#       "get",
#       "update",
#       "list",
#       "purge",
#       "recover"
#     ]

#     key_permissions = [
#       "create",
#     ]

#     secret_permissions = [
#       "set",
#     ]

#     storage_permissions = [
#       "set",
#     ]
#   }
# }

# # resource "azurerm_key_vault_certificate" "sf" {
# #   name         = "sfcert"
# #   key_vault_id = azurerm_key_vault.sf.id

# #   certificate_policy {
# #     issuer_parameters {
# #       name = "Self"
# #     }

# #     key_properties {
# #       exportable = true
# #       key_size   = 2048
# #       key_type   = "RSA"
# #       reuse_key  = true
# #     }

# #     lifetime_action {
# #       action {
# #         action_type = "AutoRenew"
# #       }

# #       trigger {
# #         days_before_expiry = 30
# #       }
# #     }

# #     secret_properties {
# #       content_type = "application/x-pkcs12"
# #     }

# #     x509_certificate_properties {
# #       extended_key_usage = [
# #         "1.3.6.1.5.5.7.3.1",
# #         "1.3.6.1.5.5.7.3.2",
# #       ]

# #       key_usage = [
# #         "cRLSign",
# #         "dataEncipherment",
# #         "digitalSignature",
# #         "keyAgreement",
# #         "keyCertSign",
# #         "keyEncipherment",
# #       ]

# #       subject            = "CN=${azurerm_lb.sf.frontend_ip_configuration[0].private_ip_address}"
# #       validity_in_months = 12
# #     }
# #   }
# # }