output "connection_string" {
  # value = {
  #   for k, db in azurerm_postgresql_flexible_server_database.default : k => db.
  # }
  value = "Server=${azurerm_postgresql_flexible_server.default.fqdn};Port=5432;User Id=${azurerm_postgresql_flexible_server.default.administrator_login};Password=${azurerm_postgresql_flexible_server.default.administrator_password};Ssl Mode=Require;"
}
