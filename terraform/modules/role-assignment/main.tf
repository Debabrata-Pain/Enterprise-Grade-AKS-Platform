resource "azurerm_role_assignment" "acr_pull_kubelet" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_object_id
}