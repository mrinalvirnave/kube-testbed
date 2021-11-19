data "azurerm_dns_zone" "main_dnszone" {
    resource_group_name = "coretools"
    name = var.dnszone
}

data "kubernetes_service" "ingress" {
    metadata {
      name = "${helm_release.ingress.name}-controller"
      namespace = helm_release.ingress.namespace
    }
}

resource "azurerm_dns_a_record" "domain" {
    name = var.domain
    zone_name = data.azurerm_dns_zone.main_dnszone.name
    resource_group_name = data.azurerm_dns_zone.main_dnszone.resource_group_name
    ttl = 300
    records = [ data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip ]
}

resource "azurerm_dns_a_record" "star-aks" {
    name = "*.${var.domain}"
    zone_name = data.azurerm_dns_zone.main_dnszone.name
    resource_group_name = data.azurerm_dns_zone.main_dnszone.resource_group_name
    ttl = 300
    records = [ data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip ]
}