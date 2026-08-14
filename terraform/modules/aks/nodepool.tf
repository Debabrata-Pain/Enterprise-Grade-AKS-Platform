resource "azurerm_kubernetes_cluster_node_pool" "user" {

  name                  = "user"

  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  vm_size               = "Standard_B2s"

  node_count            = 2

  mode                  = "User"

  os_type               = "Linux"

  vnet_subnet_id = var.user_subnet_id
  
  zones                 = ["1", "2"]

  orchestrator_version  = var.kubernetes_version

  auto_scaling_enabled   = true

  min_count             = 2

  max_count             = 5

  node_labels = {
    workload = "applications"
  }

  upgrade_settings {
  max_surge = "10%"
}

  tags = var.tags
}