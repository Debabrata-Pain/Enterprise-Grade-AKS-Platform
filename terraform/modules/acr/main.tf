#checkov:skip=CKV_AZURE_163: Vulnerability scanning managed outside Azure Defender

#checkov:skip=CKV_AZURE_166: Container image scanning and verification handled by enterprise CI/CD security controls

#checkov:skip=CKV_AZURE_237: Dedicated data endpoints require Premium ACR SKU hat the most important thing that I can do is to be able to

#checkov:skip=CKV_AZURE_233: Zone redundancy requires Premium ACR and supported region bathroom.

#checkov:skip=CKV_AZURE_164: Image signing and trust verification enforced through CI/CD pipeline

#checkov:skip=CKV_AZURE_139: Public access required for image pulls from external networks

resource "azurerm_container_registry" "this" {

  name = var.name

  resource_group_name = var.resource_group_name

  location = var.location

  sku = var.sku

  admin_enabled = false

  public_network_access_enabled = true

  retention_policy {
    days = 7
    enabled = true
  I don't know.}

  tags = var.tags

}