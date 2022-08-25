terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "0.5.0"
    }
  }
  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {
}

locals {
  module_tag = {
    "module"    = basename(abspath(path.module))
    "createdBy" = "Terraform"
  }
  tags = merge(var.default_tags, local.module_tag)
}

resource "azurerm_resource_group" "default" {
  name     = "${var.az_setting.rg_base_name}-${var.environment}"
  location = var.az_setting.location
  tags     = local.tags
}

resource "azurerm_application_insights" "default" {
  name                = "${var.application_insights.base_name}-app-insights-${var.environment}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  application_type    = var.application_insights.application_type
  tags                = local.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "${var.log_analytics.base_name}-log-analytics-workspace-${var.environment}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = var.log_analytics.sku
  tags                = local.tags
  retention_in_days   = 30

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "network" {
  source         = "./modules/network"
  base_name      = var.az_setting.network_base_name
  resource_group = azurerm_resource_group.default.name
  location       = var.az_setting.location
}

module "postgresql_server" {
  source                = "./modules/postgres"
  base_name             = "${var.environment}-${var.postgres.base_name}-server"
  resource_group        = azurerm_resource_group.default.name
  location              = azurerm_resource_group.default.location
  zone                  = var.postgres.zone
  storage_mb            = var.postgres.storage_mb
  sku_name              = var.postgres.sku_name
  backup_retention_days = var.postgres.backup_retention_days
  pg_version            = "13"

  login    = var.postgres.login
  password = var.postgres.password

  databases = var.postgres.databases

  tags = local.tags
}

module "aks_cluster" {
  source             = "./modules/aks"
  base_name          = "${var.environment}-${var.aks.base_name}"
  resource_group     = azurerm_resource_group.default.name
  location           = var.az_setting.location
  kubernetes_version = var.aks.kubernetes_version
  vnet_subnet_id     = module.network.aks_node_pool_subnet_id

  tags = local.tags
}

module "aks-resources" {
  source               = "./modules/aks-resources"
  cluster_name         = module.aks_cluster.cluster_name
  resource_group       = azurerm_resource_group.default.name
  namespaces           = var.aks_resources.namespace
  db_connection_string = module.postgresql_server.connection_string //azurerm_postgresql_flexible_server.default.fqdn
}


# module "container-apps" {
#   source                   = "./modules/container-apps"
#   managed_environment_name = "${var.container_apps.managed_environment_name}-${var.environment}"
#   resource_group_id        = azurerm_resource_group.default.id
#   location                 = azurerm_resource_group.default.location
#   tags                     = local.tags
#   instrumentation_key      = azurerm_application_insights.default.instrumentation_key
#   workspace_id             = azurerm_log_analytics_workspace.default.workspace_id
#   primary_shared_key       = azurerm_log_analytics_workspace.default.primary_shared_key
#   container_apps           = var.container_apps.apps
#   depends_on = [
#     azurerm_log_analytics_workspace.default,
#     azurerm_application_insights.default
#   ]
# } 
