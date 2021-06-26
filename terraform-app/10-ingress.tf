#
# Using regular Kubernetes nginx-ingress

resource "helm_release" "ingress" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  version = "3.31.0"
  chart = "ingress-nginx"
  name = "ingress-nginx"
  namespace = "ingress"
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

  values = []
}