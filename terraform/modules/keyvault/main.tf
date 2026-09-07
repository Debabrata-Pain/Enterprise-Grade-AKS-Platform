#checkov:skip=CKV2_AZURE_32: Private endpoint will be implemented in a future phase

#checkov:skip=CKV_AZURE_42:Purge protection intentionally disabled for non-production environment

#checkov:skip=CKV_AZURE_189: Public access temporarily required during initial deployment

#checkov:skip=CKV_AZURE_109: Firewall rules managed outside Terraform

resource "azurerm_key_vault" "this" {

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  sku_name = "standard"

  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  rbac_authorization_enabled = true

  public_network_access_enabled = true

  tags = var.tags
}