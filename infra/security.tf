# Azure Defender for Containers
resource "azurerm_security_center_subscription_pricing" "containers" {
  tier          = "Standard"
  resource_type = "Containers"
}

# Azure Defender para o ACR
resource "azurerm_security_center_subscription_pricing" "acr" {
  tier          = "Standard"
  resource_type = "ContainerRegistry"
}