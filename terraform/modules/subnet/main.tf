
resource "azurerm_subnet" "this" {

#checkov:skip=CKV2_AZURE_31:Agent subnet does not require a dedicated NSG in this project

  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name

  address_prefixes = var.address_prefixes

}

