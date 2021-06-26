variable "location" {
  description = "Azure location/region to create this resource"
  default = "eastus2"
}
variable "country" {
  description = "Two letter country code (default US) used for naming resources"
  default     = "US"
}
variable "region" {
  description = "region within the country used for naming resources"
  default     = "East2"
}

variable "aks_ssh_public_key" {}
variable "aks_admin_username" {
  default = "admin"
}

variable "tags" {
  type = map(any)

  default = {
    "owner"            = "Mrinal Virnave"
    "product"          = "demo"
    "deployment model" = "terraform"
  }
}

# AKS Variables
variable "aks_k8s_version" {
  description = "Version of Kubernetes"
  default = "1.20.5"
}

variable "aks_min_server_count" {
  description = "Minimum VM agents to run"
  default     = 1
}

variable "aks_max_server_count" {
  description = "Maximum VM agents to run"
  default     = 3
}

variable "aks_max_pods_per_node" {
  description = "Maximum number of pods to run per node"
  default = 30
}

variable "aks_osdisksize" {
  description = "Size for the OS Drive in Gigabytes"
  default     = "30"
}

variable "aks_vm_size" {
  description = "Size of AKS Virtual Machines to build"
  default     = "Standard_D2s_v3"
}
