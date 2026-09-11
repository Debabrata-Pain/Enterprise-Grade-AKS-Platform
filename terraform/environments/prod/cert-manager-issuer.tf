resource "kubernetes_manifest" "letsencrypt_staging" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name = "letsencrypt-staging"
    }

    spec = {
      acme = {
        email = var.letsencrypt_email

        server = "https://acme-staging-v02.api.letsencrypt.org/directory"

        privateKeySecretRef = {
          name = "letsencrypt-staging-account-key"
        }

        solvers = [
          {
            http01 = {
              ingress = {
                ingressClassName = "webapprouting.kubernetes.azure.com"
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [
    helm_release.cert_manager
  ]
}