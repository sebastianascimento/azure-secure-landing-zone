

# Bloqueia Storage Accounts públicos
resource "azurerm_resource_group_policy_assignment" "no_public_storage" {
  name                 = "deny-public-storage"
  resource_group_id    = azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b2982f36-99f2-4db5-8eff-283140c09693"
  display_name         = "Deny Public Storage Accounts"
  description          = "Bloqueia criação de Storage Accounts com acesso público"
}



# Obriga a tag Project em todos os recursos
resource "azurerm_resource_group_policy_assignment" "require_project_tag" {
  name                 = "require-project-tag"
  resource_group_id    = azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  display_name         = "Require Project Tag"
  description          = "Todos os recursos precisam da tag Project"

  parameters = jsonencode({
    tagName = {
      value = "Project"
    }
  })
}


# Bloqueia regiões não permitidas
resource "azurerm_resource_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  resource_group_id    = azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  display_name         = "Allowed Locations"
  description          = "Recursos só podem ser criados em regiões aprovadas"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["francecentral", "westeurope", "northeurope"]
    }
  })
}