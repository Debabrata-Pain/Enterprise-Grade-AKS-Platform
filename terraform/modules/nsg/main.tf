resource "azurerm_network_security_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
} 


resource "azurerm_network_security_rule" "nginx_http" {
  name                        = "Allow-AzureLB-Nginx-HTTP"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  destination_port_range      = "31958"

  source_address_prefix       = "Internet"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_network_security_group.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "nginx_https" {
  name                        = "Allow-AzureLB-Nginx-HTTPS"
  priority                    = 301
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  destination_port_range      = "30946"

  source_address_prefix       = "Internet"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_network_security_group.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}