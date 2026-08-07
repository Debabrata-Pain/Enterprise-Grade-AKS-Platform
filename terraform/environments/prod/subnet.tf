module "firewall_subnet" {

  source = "../../modules/subnet"

  name = "AzureFirewallSubnet"

  resource_group_name = module.network_rg.resource_group_name

  virtual_network_name = module.hub_vnet.name

  address_prefixes = ["10.0.1.0/24"]

}

module "shared_subnet" {

  source = "../../modules/subnet"

  name = "SharedServices"

  resource_group_name = module.network_rg.resource_group_name

  virtual_network_name = module.hub_vnet.name

  address_prefixes = ["10.0.2.0/24"]

}

module "aks_system_subnet" {

  source = "../../modules/subnet"

  name = "aks-system"

  resource_group_name = module.network_rg.resource_group_name

  virtual_network_name = module.aks_vnet.name

  address_prefixes = ["10.1.1.0/24"]

}

module "aks_user_subnet" {

  source = "../../modules/subnet"

  name = "aks-user"

  resource_group_name = module.network_rg.resource_group_name

  virtual_network_name = module.aks_vnet.name

  address_prefixes = ["10.1.2.0/24"]

}

module "private_endpoint_subnet" {

  source = "../../modules/subnet"

  name = "private-endpoints"

  resource_group_name = module.network_rg.resource_group_name

  virtual_network_name = module.aks_vnet.name

  address_prefixes = ["10.1.3.0/24"]

}

module "agent_subnet" {

  source = "../../modules/subnet"

  name = "agent-subnet"

  resource_group_name = module.network_rg.resource_group_name

  virtual_network_name = module.aks_vnet.name

  address_prefixes = [
    "10.1.4.0/24"
  ]

}