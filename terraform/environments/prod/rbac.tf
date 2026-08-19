module "acr_pull_role" {

  source = "../../modules/role-assignment"

  scope = module.acr.id

  role_name = "AcrPull"

  principal_id = module.aks.kubelet_object_id

}

module "agent_keyvault_secrets_role" {
  source = "../../modules/role-assignment"

  scope = module.keyvault.id

  role_name = "Key Vault Secrets Officer"

  principal_id = module.azure_devops_agent_identity.principal_id
}