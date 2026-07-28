resource "azurerm_kubernetes_cluster" "this" {

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_prefix = var.name

  kubernetes_version = var.kubernetes_version

  sku_tier = "Standard"

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  azure_policy_enabled = true

  local_account_disabled = false

  private_cluster_enabled = false

  role_based_access_control_enabled = true

  automatic_upgrade_channel = "patch"

  node_os_upgrade_channel = "NodeImage"


default_node_pool {

  name = "system"

  vm_size = "Standard_B2s"

  node_count = 2

  zones = ["1", "2"]

  os_disk_size_gb = 100

  type = "VirtualMachineScaleSets"

  only_critical_addons_enabled = true

  temporary_name_for_rotation = "systemtmp"

  vnet_subnet_id = var.system_subnet_id

}

identity {

  type = "UserAssigned"

  identity_ids = [
    var.identity_id
  ]

}

network_profile {

  network_plugin = "azure"

  network_plugin_mode = "overlay"

  network_policy = "azure"

  load_balancer_sku = "standard"

}

oms_agent {

  log_analytics_workspace_id = var.log_analytics_workspace_id

}

}