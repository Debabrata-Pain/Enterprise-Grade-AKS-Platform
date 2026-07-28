module "aks" {

  source = "../../modules/aks"

  name = "${var.environment}-aks"

  dns_prefix = "${var.environment}-aks"

  location = var.location

  resource_group_name = module.aks_rg.resource_group_name

  kubernetes_version = "1.36"

  system_subnet_id = module.aks_system_subnet.id
  user_subnet_id   = module.aks_user_subnet.id

  identity_id = module.aks_identity.id

  log_analytics_workspace_id = module.log_analytics.id

  system_node_count = 2

  system_vm_size = "Standard_B2s"

  tags = local.common_tags

}