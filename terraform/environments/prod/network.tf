module "hub_vnet" {
  source = "../../modules/vnet"

  name                = "${var.environment}-hub-vnet"
  resource_group_name = module.network_rg.resource_group_name
  location            = var.location

  address_space = ["10.0.0.0/16"]

  tags = local.common_tags
}

module "aks_vnet" {
  source = "../../modules/vnet"

  name                = "${var.environment}-aks-vnet"
  resource_group_name = module.network_rg.resource_group_name
  location            = var.location

  address_space = ["10.1.0.0/16"]

  tags = local.common_tags
}

