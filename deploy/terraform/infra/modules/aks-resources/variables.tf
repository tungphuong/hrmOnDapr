variable "resource_group" {
  type        = string
  description = "Name of the resource group"
}

variable "cluster_name" {
  type = string
}

variable "namespaces" {
  type = string
}

variable "db_connection_string" {
  type = string
}