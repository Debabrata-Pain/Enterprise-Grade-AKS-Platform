module "hub_nsg" {
  source = "../../modules/nsg"

  name                = "${var.environment}-hub-nsg"
  resource_group_name = module.network_rg.resource_group_name
  location            = var.location

  tags = local.common_tags
}

module "aks_nsg" {
  source = "../../modules/nsg"

  name                = "${var.environment}-aks-nsg"
  resource_group_name = module.network_rg.resource_group_name
  location            = var.location

  tags = local.common_tags
}

module "shared_nsg" {
  source = "../../modules/nsg"

  name                = "${var.environment}-shared-nsg"
  resource_group_name = module.network_rg.resource_group_name
  location            = var.location

  tags = local.common_tags
}