output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  value = azurerm_virtual_network.main.address_space
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "data_subnet_id" {
  value = azurerm_subnet.data.id
}

output "app_nsg_name" {
  value = azurerm_network_security_group.app.name
}

output "data_nsg_name" {
  value = azurerm_network_security_group.data.name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_private_ip" {
  description = "IP privado do Storage Account dentro da VNet"
  value       = azurerm_private_endpoint.storage.private_service_connection[0].private_ip_address
}

output "keyvault_name" {
  value = azurerm_key_vault.main.name
}

output "keyvault_private_ip" {
  description = "IP privado do Key Vault dentro da VNet"
  value       = azurerm_private_endpoint.keyvault.private_service_connection[0].private_ip_address
}

output "managed_identity_id" {
  description = "ID da Managed Identity"
  value       = azurerm_user_assigned_identity.app.id
}

output "managed_identity_client_id" {
  description = "Client ID da Managed Identity"
  value       = azurerm_user_assigned_identity.app.client_id
}

output "developers_group_id" {
  description = "ID do grupo Developers"
  value       = azuread_group.developers.object_id
}