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

module "flask_identity" {

  source = "../../modules/managed-identity"

  name                = "${var.environment}-flask-identity"

  location            = var.location
  
  resource_group_name = module.shared_rg.resource_group_name

  tags = local.common_tags
}

resource "azurerm_federated_identity_credential" "flask" {

  name = "${var.environment}-flask-federated-credential"

  resource_group_name = module.shared_rg.resource_group_name

  parent_id = module.flask_identity.id

  audience = [
    "api://AzureADTokenExchange"
  ]

  issuer = module.aks.oidc_issuer_url

  subject = "system:serviceaccount:default:enterprise-flask-sa"
}