module "acr_pull_role" {

  source = "../../modules/role-assignment"

  scope = module.acr.id

  role_name = "AcrPull"

  principal_id = module.aks.kubelet_object_id

}