output "flexible_servers_subnet_id" {
  value = azurerm_subnet.flexible_servers_subnet.id
}

# output "postgres_pdz_id" {
#   value = azurerm_private_dns_zone.postgres_pdz.id
# }

output "aks_node_pool_subnet_id" {
  value = azurerm_subnet.aks_node_pool_subnet.id
}
