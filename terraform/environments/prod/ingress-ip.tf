data "azurerm_resource_group" "aks" {
  name = module.aks_rg.resource_group_name
}

resource "azurerm_public_ip" "aks_ingress" {
  name                = "${var.environment}-aks-ingress-ip"
  resource_group_name = module.aks_rg.resource_group_name
  location            = var.location

  allocation_method = "Static"
  sku               = "Standard"

  tags = local.common_tags
}

resource "azurerm_role_assignment" "aks_ingress_network_contributor" {
  scope                = data.azurerm_resource_group.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks_identity.principal_id
}

output "aks_ingress_public_ip" {
  description = "Static public IP address for AKS ingress"
  value       = azurerm_public_ip.aks_ingress.ip_address
}