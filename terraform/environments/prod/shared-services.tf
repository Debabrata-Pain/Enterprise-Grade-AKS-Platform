module "acr" {

  source = "../../modules/acr"

  name = "prodaksacrdeb2026"

  location = var.location

  resource_group_name = module.shared_rg.resource_group_name

  sku = "Basic"

  tags = local.common_tags

}