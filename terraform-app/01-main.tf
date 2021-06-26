# This configures the base elements of the kubernetes cluster getting values from the
# int-infrastructure terraform run

# Connect to the cluster created in int-terraform for the following 3 providers

provider "helm" {
  kubernetes {
    client_certificate = base64decode(data.terraform_remote_state.aks_cluster.outputs.kubernetes_client_certificate)
    client_key = base64decode(data.terraform_remote_state.aks_cluster.outputs.kubernetes_client_key)
    cluster_ca_certificate = base64decode(data.terraform_remote_state.aks_cluster.outputs.kubernetes_cluster_ca_certificate)
    host = data.terraform_remote_state.aks_cluster.outputs.kubernetes_host
  }
}

provider "kubernetes" {
  client_certificate = base64decode(data.terraform_remote_state.aks_cluster.outputs.kubernetes_client_certificate)
  client_key = base64decode(data.terraform_remote_state.aks_cluster.outputs.kubernetes_client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.aks_cluster.outputs.kubernetes_cluster_ca_certificate)
  host = data.terraform_remote_state.aks_cluster.outputs.kubernetes_host

}

provider "azurerm" {
    features {}
}

//provider "kubectl" {
//  load_config_file       = false
//  client_certificate     = base64decode(data.terraform_remote_state.aks_cluster.outputs.kubernetes_client_certificate)
//  client_key             = base64decode(data.terraform_remote_state.aks_cluster.outputs.kubernetes_client_key)
//  cluster_ca_certificate = base64decode(data.terraform_remote_state.aks_cluster.outputs.kubernetes_cluster_ca_certificate)
//  host                   = data.terraform_remote_state.aks_cluster.outputs.kubernetes_host
//}

terraform {
  required_version = ">= 0.15"
  required_providers {
//    kubectl = {
//      source = "gavinbunney/kubectl"
//      version = "1.11.1"
//    }
    helm = {
      source = "hashicorp/helm"
      version = "2.1.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.57.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "mvconfigstore"
    container_name       = "testbed"
    key                  = "app.tfstate"
    # for security reasons we don't specify the access_key here.  instead set the environment variable ARM_ACCESS_KEY.
  }
}

data "terraform_remote_state" "aks_cluster" {
  backend   = "azurerm"
  workspace = terraform.workspace

  config = {
    storage_account_name = "mvconfigstore"
    container_name       = "testbed"
    key                  = "infra.tfstate"
  }
}
