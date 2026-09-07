#checkov:skip=CKV2_AZURE_31:NSGs are managed separately from subnet module

resource "azurerm_subnet" "this" {

  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name

  address_prefixes = var.address_prefixes

}

