terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
  experiments = [module_variable_optional_attrs]
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
}

data "azurerm_kubernetes_cluster" "default" {
  name                = var.cluster_name
  resource_group_name = var.resource_group
  lifecycle {
    postcondition {
      condition     = self.tags["createdBy"] == "Terraform"
      error_message = "tags[\"createdBy\"] must be \"Terraform\"."
    }
  }
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = var.namespaces
  }
}

resource "kubernetes_config_map" "dbConfig" {
  metadata {
    name = "dbconfig"
  }
  data = {
    dbConnection = "${var.db_connection_string};Database=adminDb"
  }
}
