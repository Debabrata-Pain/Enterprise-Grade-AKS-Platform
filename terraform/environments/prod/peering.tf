module "hub_to_aks" {

  source = "../../modules/vnet-peering"

  name = "hub-to-aks"

  resource_group_name = module.network_rg.resource_group_name

  virtual_network_name = module.hub_vnet.name

  remote_virtual_network_id = module.aks_vnet.id

}

module "aks_to_hub" {

  source = "../../modules/vnet-peering"

  name = "aks-to-hub"

  resource_group_name = module.network_rg.resource_group_name

  virtual_network_name = module.aks_vnet.name

  remote_virtual_network_id = module.hub_vnet.id

}

