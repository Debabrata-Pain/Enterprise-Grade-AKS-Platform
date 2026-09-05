data "azurerm_key_vault" "bootstrap" {
  name                = "prod-bootstrap-kv"
  resource_group_name = "prod-bootstrap-rg"
}