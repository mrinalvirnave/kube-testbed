resource "kubernetes_deployment" "echo1" {
  metadata {
    name = "echo1"
  }
  spec {
    selector {
      match_labels = {
        app = "echo1"
      }
    }
    replicas = "1"
    template {

      metadata {
        labels = {
          app = "echo1"
        }
      }
      spec {
        container {
          name = "echo1"
          image = "hashicorp/http-echo"
          args = [ "-text=<h1>echo1</h1>" ]
          port {
            container_port = 5678
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "echo1" {
  metadata {
    name = "echo1"
  }
  spec {
    port {
      port = 80
      target_port = kubernetes_deployment.echo1.spec.0.template.0.spec.0.container.0.port.0.container_port
      protocol = "TCP"
    }
    selector = {
      app = "echo1"
    }
  }
}

resource "kubernetes_deployment" "echo2" {
  metadata {
    name = "echo2"
  }
  spec {
    selector {
      match_labels = {
        app = "echo2"
      }
    }
    replicas = "1"
    template {

      metadata {
        labels = {
          app = "echo2"
        }
      }
      spec {
        container {
          name = "echo2"
          image = "hashicorp/http-echo"
          args = [ "-text=<h1>echo2</h1>" ]
          port {
            container_port = 5678
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "echo2" {
  metadata {
    name = "echo2"
  }
  spec {
    port {
      port = 80
      target_port = kubernetes_deployment.echo2.spec.0.template.0.spec.0.container.0.port.0.container_port
      protocol = "TCP"
    }
    selector = {
      app = "echo2"
    }
  }
}

resource "kubernetes_ingress" "echo" {
  metadata {
    name = "echo2"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
  }
  spec {
    tls {
      hosts = [
        "echo1.${trimsuffix(azurerm_dns_a_record.aks.fqdn, ".")}",
        "echo2.${trimsuffix(azurerm_dns_a_record.aks.fqdn, ".")}"
      ]
      secret_name = "echo-tls"
    }
    rule {
      host = "echo1.${trimsuffix(azurerm_dns_a_record.aks.fqdn, ".")}"
      http {
        path {
          backend {
            service_name = kubernetes_service.echo1.metadata.0.name
            service_port = kubernetes_service.echo1.spec.0.port.0.port
          }
        }
      }
    }
    rule {
      host = "echo2.${trimsuffix(azurerm_dns_a_record.aks.fqdn, ".")}"
      http {
        path {
          backend {
            service_name = kubernetes_service.echo2.metadata.0.name
            service_port = kubernetes_service.echo2.spec.0.port.0.port
          }
        }
      }
    }
  }
}