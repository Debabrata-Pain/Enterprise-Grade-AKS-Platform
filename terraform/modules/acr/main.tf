#checkov:skip=CKV_AZURE_163: Vulnerability scanning managed outside Azure Defender

#checkov:skip=CKV_AZURE_166: Container image scanning and verification handled by enterprise CI/CD security controls

#checkov:skip=CKV_AZURE_237: Dedicated data endpoints require Premium ACR SKU s is a short segment, but it is a I Okay, so You guys check I think I I Oh.

#checkov:skip=CKV_AZURE_233: Zone redundancy requires Premium ACR and supported region bathroom.

#checkov:skip=CKV_AZURE_164: Image signing and trust verification enforced through CI/CD pipeline

#checkov:skip=CKV_AZURE_139: Public access required for image pulls from external networks

#checkov:skip=CKV_AZURE_167: Retention policy not supported by current provider version

resource "azurerm_container_registry" "this" {

  name = var.name

  resource_group_name = var.resource_group_name

  location = var.location

  sku = var.sku

  admin_enabled = false

  public_network_access_enabled = true

  tags = var.tags

}