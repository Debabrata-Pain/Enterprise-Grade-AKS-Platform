resource "azurerm_public_ip" "this" {

  name                = "${var.vm_name}-pip"

  location            = var.location

  resource_group_name = var.resource_group_name

  allocation_method   = "Static"

  sku                 = "Standard"

}

resource "azurerm_network_interface" "this" {

  name                = "${var.vm_name}-nic"

  location            = var.location

  resource_group_name = var.resource_group_name

  ip_configuration {

    name                          = "internal"

    subnet_id                     = var.subnet_id

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id          = azurerm_public_ip.this.id

  }

}

resource "azurerm_network_security_group" "this" {

  name = "${var.vm_name}-nsg"

  location = var.location

  resource_group_name = var.resource_group_name

}

resource "azurerm_network_security_rule" "ssh" {

  name = "Allow-SSH"

  priority = 100

  direction = "Inbound"

  access = "Allow"

  protocol = "Tcp"

  source_port_range = "*"

  destination_port_range = "22"

  source_address_prefix = var.allowed_ssh_ip

  destination_address_prefix = "*"

  resource_group_name = var.resource_group_name

  network_security_group_name = azurerm_network_security_group.this.name

}

resource "azurerm_network_interface_security_group_association" "this" {

  network_interface_id = azurerm_network_interface.this.id

  network_security_group_id = azurerm_network_security_group.this.id

}

resource "azurerm_linux_virtual_machine" "this" {

  name = var.vm_name

  resource_group_name = var.resource_group_name

  location = var.location

  size = var.vm_size

  admin_username = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  identity {
  type = "SystemAssigned"
  }

  disable_password_authentication = true

  admin_ssh_key {

    username = var.admin_username

    public_key = var.public_key

  }

  os_disk {

    caching = "ReadWrite"

    storage_account_type = "Standard_LRS"

  }

  source_image_reference {

    publisher = "Canonical"

    offer = "ubuntu-24_04-lts"

    sku = "server"

    version = "latest"

  }
  boot_diagnostics {}
  tags = var.tags

}