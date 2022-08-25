resource "azurerm_virtual_network" "default" {
  name                = "${var.base_name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_security_group" "default" {
  name                = "${var.base_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "${var.base_name}-nsg-inbound-rule-allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

// postgres flexible servers subnet
resource "azurerm_subnet" "flexible_servers_subnet" {
  name                 = "${var.base_name}-flexible-servers-subnet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = var.resource_group
  address_prefixes     = ["10.0.1.0/27"]
  service_endpoints    = ["Microsoft.Storage"]

  # delegation {
  #   name = "fs"

  #   service_delegation {
  #     name = "Microsoft.DBforPostgreSQL/flexibleServers"

  #     actions = [
  #       "Microsoft.Network/virtualNetworks/subnets/join/action",
  #     ]
  #   }
  # }
}

# resource "azurerm_subnet_network_security_group_association" "flexible_servers_subnet_nsga" {
#   subnet_id                 = azurerm_subnet.flexible_servers_subnet.id
#   network_security_group_id = azurerm_network_security_group.default.id
# }

# resource "azurerm_private_dns_zone" "postgres_pdz" {
#   name                = "${var.base_name}-pdz.postgres.database.azure.com"
#   resource_group_name = var.resource_group

#   depends_on = [azurerm_subnet_network_security_group_association.flexible_servers_subnet_nsga]
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "default" {
#   name                  = "${var.base_name}-pdzvnetlink.com"
#   private_dns_zone_name = azurerm_private_dns_zone.postgres_pdz.name
#   virtual_network_id    = azurerm_virtual_network.default.id
#   resource_group_name   = var.resource_group
# }

// aks node pool subnet
resource "azurerm_subnet" "aks_node_pool_subnet" {
  name = "${var.base_name}-aks-node-pool-subnet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = var.resource_group
  address_prefixes     = ["10.0.4.0/22"]
}