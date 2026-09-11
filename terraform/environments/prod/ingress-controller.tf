resource "kubernetes_manifest" "nginx_ingress_controller" {
  manifest = {
    apiVersion = "approuting.kubernetes.azure.com/v1alpha1"
    kind       = "NginxIngressController"

    metadata = {
      name = "default"
    }

    spec = {
      controllerNamePrefix = "nginx"
      ingressClassName     = "webapprouting.kubernetes.azure.com"

      loadBalancerAnnotations = {
        "service.beta.kubernetes.io/azure-load-balancer-internal"       = "false"
        "service.beta.kubernetes.io/azure-pip-name"                     = azurerm_public_ip.aks_ingress.name
        "service.beta.kubernetes.io/azure-load-balancer-resource-group" = azurerm_public_ip.aks_ingress.resource_group_name

        "service.beta.kubernetes.io/azure-disable-load-balancer-floating-ip" = "true"
      }
    }
  }

  depends_on = [
    azurerm_role_assignment.aks_ingress_network_contributor
  ]
}