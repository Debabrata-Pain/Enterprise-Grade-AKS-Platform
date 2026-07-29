locals {

  common_tags = {

    Environment = "Production"

    Project = "Enterprise-AKS"

    Owner = "Debabrata"

    ManagedBy = "Terraform"

  }

}

module "network_rg" {

  source = "../../modules/resource-group"

  name = "${var.environment}-network-rg"

  location = var.location

  tags = local.common_tags

}

module "aks_rg" {

  source = "../../modules/resource-group"

  name = "${var.environment}-aks-rg"

  location = var.location

  tags = local.common_tags

}

module "shared_rg" {

  source = "../../modules/resource-group"

  name = "${var.environment}-shared-rg"

  location = var.location

  tags = local.common_tags

}

module "monitoring_rg" {

  source = "../../modules/resource-group"

  name = "${var.environment}-monitoring-rg"

  location = var.location

  tags = local.common_tags

}

locals {
  prefix = "${var.environment}-aks"

  common_tags = {
    Environment = var.environment
    Project     = "Enterprise-AKS"
    Owner       = "Debabrata"
    ManagedBy   = "Terraform"
  }
}