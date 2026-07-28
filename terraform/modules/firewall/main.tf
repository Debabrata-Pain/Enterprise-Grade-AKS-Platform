resource "azurerm_public_ip" "firewall" {

  name                = "${var.name}-pip"

  resource_group_name = var.resource_group_name

  location            = var.location

  allocation_method   = "Static"

  sku                 = "Standard"

  tags = var.tags

}

resource "azurerm_firewall" "this" {

  name                = var.name

  location            = var.location

  resource_group_name = var.resource_group_name

  sku_name = "AZFW_VNet"

  sku_tier = "Standard"

  firewall_policy_id = var.firewall_policy_id

  ip_configuration {

    name = "configuration"

    subnet_id = var.subnet_id

    public_ip_address_id = azurerm_public_ip.firewall.id

  }

  tags = var.tags

}