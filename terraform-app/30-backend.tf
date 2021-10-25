resource "kubernetes_deployment" "kuard" {
  metadata {
    name = "kuard"
  }
  spec {
    selector {
      match_labels = {
        app = "kuard"
      }
    }
    replicas = "1"
    template {

      metadata {
        labels = {
          app = "kuard"
        }
      }
      spec {
        container {
          name = "kuard"
          image = "gcr.io/kuar-demo/kuard-amd64:1"
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kuard" {
  metadata {
    name = "kuard"
  }
  spec {
    port {
      port = 80
      target_port = kubernetes_deployment.kuard.spec.0.template.0.spec.0.container.0.port.0.container_port
      protocol = "TCP"
    }
    selector = {
      app = "kuard"
    }
  }
}

resource "kubernetes_ingress" "kuard" {
  metadata {
    name = "kuard"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    tls {
      hosts = [ trimsuffix(azurerm_dns_a_record.aks.fqdn, ".") ]
      secret_name = "eduinks-net-tls"
    }
    rule {
      host = trimsuffix(azurerm_dns_a_record.aks.fqdn, ".")
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.kuard.metadata.0.name
            service_port = kubernetes_service.kuard.spec.0.port.0.port
          }
        }
      }
    }
  }
}