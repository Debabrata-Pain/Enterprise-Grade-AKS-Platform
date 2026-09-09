# terraform/environments/prod/nsg.tf


# =========================================================
# AKS NSG
# =========================================================

resource "azurerm_subnet_network_security_group_association" "aks_system" {

  subnet_id                 = module.aks_system_subnet.id
  network_security_group_id = module.aks_nsg.id

}


resource "azurerm_subnet_network_security_group_association" "aks_user" {

  subnet_id                 = module.aks_user_subnet.id
  network_security_group_id = module.aks_nsg.id

}

# =========================================================
# AKS Ingress - HTTP
# =========================================================

resource "azurerm_network_security_rule" "aks_ingress_http" {

  name                        = "Allow-HTTP-Ingress"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  destination_port_range      = "80"

  source_address_prefix       = "*"
  destination_address_prefix  = "*"

  resource_group_name         = module.network_rg.resource_group_name
  network_security_group_name = module.aks_nsg.name

}

# =========================================================
# Azure DevOps Agent Subnet NSG
# =========================================================

module "agent_subnet_nsg" {

  source = "../../modules/nsg"

  name                = "${var.environment}-agent-subnet-nsg"
  location            = var.location
  resource_group_name = module.network_rg.resource_group_name

  tags = local.common_tags

}


resource "azurerm_subnet_network_security_group_association" "agent_subnet" {

  subnet_id                 = module.agent_subnet.id
  network_security_group_id = module.agent_subnet_nsg.id

}


# =========================================================
# Shared Services Subnet -> Shared NSG
# =========================================================

resource "azurerm_subnet_network_security_group_association" "shared" {

  subnet_id                 = module.shared_subnet.id
  network_security_group_id = module.shared_nsg.id

}


# =========================================================
# Firewall Subnet
# =========================================================
#
# Do NOT attach an NSG here for now.
#
# AzureFirewallSubnet has specific Azure Firewall
# requirements. We should not add an NSG merely to
# satisfy Checkov without validating that design.
#