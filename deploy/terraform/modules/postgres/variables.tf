variable "base_name" {
  type        = string
  description = "The virtual network base name"
}

variable "resource_group" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "The location for the deployment"
}

variable "tags" {
  type = map(any)
}

variable "login" {
  type = string
}

variable "password" {
  type = string
}

variable "zone" {
  type = string
}

variable "storage_mb" {
  type = number
}

variable "sku_name" {
  type = string
}

variable "backup_retention_days" {
  type = number
}

variable "pg_version" {
  type = string
}

# variable "delegated_subnet_id" {
#   type = string
# }

# variable "private_dns_zone_id" {
#   type = string
# }

variable "databases" {
  type = map(object({
    name      = string
    collation = string
    charset   = string
  }))
}
