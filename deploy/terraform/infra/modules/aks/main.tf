locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.module_tag)
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.resource_group
  location            = var.location
  tags                = local.tags

  name = "${var.base_name}-identity"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${var.base_name}-aks"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = local.tags
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = lower("${var.base_name}-aks")

  default_node_pool {
    name           = "agentpool"
    node_count     = var.default_node_pool_node_count
    vm_size        = var.default_node_pool_vm_size
    vnet_subnet_id = var.vnet_subnet_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  network_profile {
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.2.0.10"
    network_plugin     = "azure"
    outbound_type      = "loadBalancer"
    service_cidr       = "10.2.0.0/24"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
