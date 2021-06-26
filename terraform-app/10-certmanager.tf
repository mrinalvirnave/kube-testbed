resource "helm_release" "cert-manager" {
  repository = "https://charts.jetstack.io"
  version = "v1.4.0-beta.0"
  chart = "cert-manager"
  name = "cert-manager"
  namespace = "cert-manager"
  create_namespace = "true"
  set {
    name = "installCRDs"
    value = "true"
  }
}