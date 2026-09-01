output "id" {
  description = "AKS Cluster ID"
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "AKS Cluster Name"
  value       = azurerm_kubernetes_cluster.this.name
}

output "kubelet_object_id" {
  description = "Kubelet Managed Identity Object ID"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "kubelet_client_id" {
  description = "Kubelet Managed Identity Client ID"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].client_id
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.this.node_resource_group
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
}