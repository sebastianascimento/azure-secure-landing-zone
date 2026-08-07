
# Storage Account — vive na subnet privada
resource "azurerm_storage_account" "main" {
  name                     = "seclzsebastorage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # Bloqueia acesso público
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  # Directivas do Checkov
  #checkov:skip=CKV2_AZURE_1: Usando chaves geridas pela Microsoft (MMK) por eficiencia de custos em dev/lab.
  #checkov:skip=CKV_AZURE_33: O servico de Queue Storage nao e utilizado nesta arquitetura.

  # TLS mais recente
  min_tls_version = "TLS1_2"

  # Desativa Shared Key usa só Entra ID
  shared_access_key_enabled = false

  sas_policy {
    expiration_period = "90.00:00:00"
  }

  # Soft delete para blobs e containers
  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Key Vault — vive na subnet privada
resource "azurerm_key_vault" "main" {
  name                = "seclz-seba-kv"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Bloqueia acesso público
  public_network_access_enabled = false

  # Recuperação e proteção contra eliminação acidental
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  # Firewall — só permite acesso via Private Endpoint
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "List", "Set", "Delete"]
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Private Endpoint — Storage Account
resource "azurerm_private_endpoint" "storage" {
  name                = "storage-private-endpoint"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.data.id

  private_service_connection {
    name                           = "storage-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}



# Private Endpoint — Key Vault
resource "azurerm_private_endpoint" "keyvault" {
  name                = "keyvault-private-endpoint"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.data.id

  private_service_connection {
    name                           = "keyvault-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Private DNS Zone — Storage
resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Private DNS Zone — Key Vault
resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Liga DNS Zone à VNet — Storage
resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = "storage-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Liga DNS Zone à VNet — Key Vault
resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "keyvault-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# DNS Record — Storage
resource "azurerm_private_dns_a_record" "storage" {
  name                = "seclzsebastorage"
  zone_name           = azurerm_private_dns_zone.storage.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.storage.private_service_connection[0].private_ip_address]
}

# DNS Record — Key Vault
resource "azurerm_private_dns_a_record" "keyvault" {
  name                = "seclz-seba-kv"
  zone_name           = azurerm_private_dns_zone.keyvault.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.keyvault.private_service_connection[0].private_ip_address]
}