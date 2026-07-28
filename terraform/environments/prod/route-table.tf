module "hub_rt" {

  source = "../../modules/route-table"

  name = "${var.environment}-hub-rt"

  location = var.location

  resource_group_name = module.network_rg.resource_group_name

  tags = local.common_tags

}

module "aks_rt" {

  source = "../../modules/route-table"

  name = "${var.environment}-aks-rt"

  location = var.location

  resource_group_name = module.network_rg.resource_group_name

  tags = local.common_tags

}

module "shared_rt" {

  source = "../../modules/route-table"

  name = "${var.environment}-shared-rt"

  location = var.location

  resource_group_name = module.network_rg.resource_group_name

  tags = local.common_tags

}