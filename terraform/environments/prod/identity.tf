module "aks_identity" {

  source = "../../modules/managed-identity"

  name = "${var.environment}-aks-identity"

  location = var.location

  resource_group_name = module.shared_rg.resource_group_name

  tags = local.common_tags

}

module "azure_devops_agent_identity" {

  source = "../../modules/managed-identity"

  name = "${var.environment}-ado-agent-identity"

  location = var.location

  resource_group_name = module.shared_rg.resource_group_name

  tags = local.common_tags

}
