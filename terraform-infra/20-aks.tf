# This is the aks terraform stack.
# It creates an AKS cluster for use with TREX

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "AKS-${var.country}-${var.region}-TESTBED"
  location            = var.location
  resource_group_name = azurerm_resource_group.testbed.name
  dns_prefix          = "testbed"
  kubernetes_version  = var.aks_k8s_version

  node_resource_group = "RG-${var.country}-${var.region}-TESTBED-AKSNODES"
  default_node_pool {
    name                 = "default"
    orchestrator_version = var.aks_k8s_version
    vm_size              = var.aks_vm_size
    type                 = "VirtualMachineScaleSets"
    enable_auto_scaling  = true
    min_count            = var.aks_min_server_count
    max_count            = var.aks_max_server_count
    os_disk_size_gb      = var.aks_osdisksize
    max_pods             = var.aks_max_pods_per_node
    tags = merge(var.tags, tomap({role = "aks_default_node_pool"}))
  }

  linux_profile {
    admin_username = var.aks_admin_username
    ssh_key {
      key_data = file(var.aks_ssh_public_key)
    }
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
      azure_rbac_enabled = true
    }
  }

  addon_profile {
    kube_dashboard {
      enabled = false
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, tomap({role = "aks_cluster"}))

  //lifecycle {
  //  ignore_changes = [
  //    default_node_pool.node_count
  //  ]
  //}

}

output "kubernetes_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}
output "kubernetes_host" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.host
}
output "kubernetes_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.cluster_ca_certificate
  sensitive = true
}
output "kubernetes_client_key" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.client_key
  sensitive = true
}
output "kubernetes_client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config.0.client_certificate
  sensitive = true
}
output "aks_resource_group_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
}
output "aks_location" {
  value = azurerm_kubernetes_cluster.aks_cluster.location
}
output "aks_principal_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
}

output "aks_kubelet_principal_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}

output "aks_kubelet_client_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].client_id
}

output "aks_kubelet_resource_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].user_assigned_identity_id
}

output "aks_tenant_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.identity[0].tenant_id
}