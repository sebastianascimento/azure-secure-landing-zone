

resource "azuread_user" "developer" {
  user_principal_name = "user-dev@${var.tenant_domain}"
  display_name        = "Developer Test"
  password            = var.test_user_password
  force_password_change = false
}


resource "azuread_user" "secadmin" {
  user_principal_name = "user-secadmin@${var.tenant_domain}"
  display_name        = "Security Admin Test"
  password            = var.test_user_password
  force_password_change = false
}


resource "azuread_group" "developers" {
  display_name     = "Developers"
  security_enabled = true
  members = [
    azuread_user.developer.object_id
  ]
}


resource "azuread_group" "security_admins" {
  display_name     = "SecurityAdmins"
  security_enabled = true
  members = [
    azuread_user.secadmin.object_id
  ]
}


resource "azurerm_role_assignment" "developers_reader" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.developers.object_id
}

resource "azurerm_role_assignment" "secadmins_security_reader" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Security Reader"
  principal_id         = azuread_group.security_admins.object_id
}


resource "azurerm_role_assignment" "secadmins_keyvault" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_group.security_admins.object_id
}


resource "azurerm_user_assigned_identity" "app" {
  name                = "${var.project_name}-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "azurerm_role_assignment" "app_keyvault" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}

resource "azurerm_role_assignment" "app_storage" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}


resource "azuread_conditional_access_policy" "mfa_location" {
  display_name = "ZeroTrust-RequireMFA-Outside-PT"
  state        = "enabledForReportingButNotEnforced"  # ← Report-only primeiro

  conditions {
    client_app_types = ["all"]
    users {
      included_groups = [
        azuread_group.developers.object_id,
        azuread_group.security_admins.object_id
      ]
    }
    applications {
      included_applications = ["All"]
    }
    locations {
      included_locations = ["All"]
      excluded_locations = ["AllTrusted"]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}