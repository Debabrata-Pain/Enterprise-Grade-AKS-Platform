module "acr_pull_role" {

  source = "../../modules/role-assignment"

  scope        = module.acr.id
  role_name    = "AcrPull"
  principal_id = module.aks.kubelet_object_id

}

module "ado_acr_push_role" {
  source = "../../modules/role-assignment"

  scope        = module.acr.id
  role_name    = "AcrPush"
  principal_id = var.ado_acr_service_principal_object_id
}

module "agent_bootstrap_keyvault_role" {
  source = "../../modules/role-assignment"

  scope = data.azurerm_key_vault.bootstrap.id

  role_name = "Key Vault Secrets User"

  principal_id = module.azure_devops_agent_identity.principal_id
}

module "enterprise_flask_keyvault_role" {
  source = "../../modules/role-assignment"

  scope        = module.keyvault.id
  role_name    = "Key Vault Secrets User"
  principal_id = module.enterprise_flask_identity.principal_id
}