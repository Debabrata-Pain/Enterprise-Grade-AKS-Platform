resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  repository = "oci://quay.io/jetstack/charts"
  chart      = "cert-manager"
  version    = "v1.21.1"

  set = [
    {
      name  = "crds.enabled"
      value = "true"
    }
  ]

  wait    = true
  timeout = 600

  depends_on = [
    module.aks
  ]
}