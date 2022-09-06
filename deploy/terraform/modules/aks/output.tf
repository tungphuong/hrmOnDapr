output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}
