terraform {

  backend "azurerm" {

    resource_group_name = "prod-tfstate-rg"

    storage_account_name = "prodtfstatedeb2026"

    container_name = "tfstate"

    key = "prod/terraform.tfstate"

  }

}