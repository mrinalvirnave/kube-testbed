resource "helm_release" "argocd" {
  depends_on = [kubernetes_manifest.clusterissuer_letsencrypt_staging, kubernetes_manifest.clusterissuer_letsencrypt_prod]
  repository = "https://argoproj.github.io/argo-helm"
  version = "3.26.3"
  chart = "argo-cd"
  name = "argo-cd"
  namespace = "argo-cd"
  create_namespace = "true"

  // Uncomment the Following of Internal loadbalancer is desired
  //  set {
  //    name  = "controller.service.loadBalancerIP"
  //    value = var.ingress_ip
  //  }

  //  set {
  //    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
  //    value = "true"
  //  }

  values = [
    <<-EOF
    server:
      config:
        url: argocd.${trimsuffix(azurerm_dns_a_record.aks.fqdn, ".")}
      ingress:
        enabled: true
        annotations:
          cert-manager.io/cluster-issuer: letsencrypt-prod
          kubernetes.io/ingress.class: nginx
          kubernetes.io/tls-acme: "true"
          nginx.ingress.kubernetes.io/ssl-passthrough: "true"
          nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
        tls:
          - secretName: argocd-secret
            hosts:
              - argocd.${trimsuffix(azurerm_dns_a_record.aks.fqdn, ".")}
        ingressClassName: nginx
        hosts:
          - argocd.${trimsuffix(azurerm_dns_a_record.aks.fqdn, ".")}

    EOF
  ]
}