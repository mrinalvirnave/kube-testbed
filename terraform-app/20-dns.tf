data "azurerm_dns_zone" "eduinks_net" {
    resource_group_name = "coretools"
    name = "eduinks.net"
}

data "kubernetes_service" "ingress" {
    metadata {
      name = "${helm_release.ingress.name}-controller"
      namespace = helm_release.ingress.namespace
    }
}

resource "azurerm_dns_a_record" "aks" {
    name = "aks"
    zone_name = data.azurerm_dns_zone.eduinks_net.name
    resource_group_name = data.azurerm_dns_zone.eduinks_net.resource_group_name
    ttl = 300
    records = [ data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip ]
}

resource "azurerm_dns_a_record" "star-aks" {
    name = "*.aks"
    zone_name = data.azurerm_dns_zone.eduinks_net.name
    resource_group_name = data.azurerm_dns_zone.eduinks_net.resource_group_name
    ttl = 300
    records = [ data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip ]
}