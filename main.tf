terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.59.0"

    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id = var.serviceprinciple_id
  client_secret = var.serviceprinciple_key
  tenant_id = var.tenant_id

  features {}
}

module "cluster" {
  source = "./modules/cluster"
  serviceprinciple_id = var.serviceprinciple_id
  serviceprinciple_key = var.serviceprinciple_key
  location = var.location
  kubernetes_version = var.kubernetes_version
  ssh_key = var.ssh_key
  service_principal_obj_id = var.service_principal_obj_id
}

module "k8s" {
  source = "./modules/k8s"
  host = module.cluster.host
  client_certificate = base64decode(module.cluster.client_certificate)
  client_key = base64decode(module.cluster.client_key)
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
}