#checkov:skip=CKV_AZURE_220: IDPS not supported by current provider version

resource "azurerm_firewall_policy" "this" {

  name                = var.name

  resource_group_name = var.resource_group_name

  location            = var.location

  sku = "Standard"

  tags = var.tags

}