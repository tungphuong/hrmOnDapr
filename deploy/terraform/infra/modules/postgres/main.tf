locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.module_tag)
}

resource "azurerm_postgresql_flexible_server" "default" {
  name                  = var.base_name
  resource_group_name   = var.resource_group
  location              = var.location
  version               = var.pg_version
  zone                  = var.zone
  storage_mb            = var.storage_mb
  sku_name              = var.sku_name
  backup_retention_days = var.backup_retention_days

  administrator_login    = var.login
  administrator_password = var.password

  tags = local.tags
}

resource "azurerm_postgresql_flexible_server_database" "default" {
  for_each = var.databases

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.default.id
  collation = each.value.collation
  charset   = each.value.charset
}
