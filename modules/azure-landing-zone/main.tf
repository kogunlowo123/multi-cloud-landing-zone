# -----------------------------------------------------------------------------
# Management Group Hierarchy
# -----------------------------------------------------------------------------
resource "azurerm_management_group" "root" {
  display_name = var.root_management_group_name
}

resource "azurerm_management_group" "platform" {
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "identity" {
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "connectivity" {
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "management" {
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "landing_zones" {
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "corp" {
  display_name               = "Corp"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "online" {
  display_name               = "Online"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "sandbox" {
  display_name               = "Sandbox"
  parent_management_group_id = azurerm_management_group.root.id
}

# -----------------------------------------------------------------------------
# Azure Policy - Allowed Locations
# -----------------------------------------------------------------------------
resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  management_group_id  = azurerm_management_group.root.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  display_name         = "Allowed locations"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}

# -----------------------------------------------------------------------------
# Azure Policy - Require Tags
# -----------------------------------------------------------------------------
resource "azurerm_management_group_policy_assignment" "require_tags" {
  name                 = "require-env-tag"
  management_group_id  = azurerm_management_group.landing_zones.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  display_name         = "Require Environment tag"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}

# -----------------------------------------------------------------------------
# Microsoft Defender for Cloud
# -----------------------------------------------------------------------------
resource "azurerm_security_center_subscription_pricing" "defender" {
  for_each = var.enable_defender ? toset(["VirtualMachines", "SqlServers", "AppServices", "StorageAccounts", "KeyVaults", "Containers"]) : toset([])

  tier          = "Standard"
  resource_type = each.key
}

# -----------------------------------------------------------------------------
# Log Analytics Workspace
# -----------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "central" {
  name                = "${lower(var.root_management_group_name)}-central-logs"
  location            = var.primary_location
  resource_group_name = var.management_resource_group
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days

  tags = var.tags
}
