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

variable "kubernetes_version" {
  type = string
}

variable "default_node_pool_node_count" {
  type    = number
  default = 1
}

variable "default_node_pool_vm_size" {
  description = "Specifies the vm size of the default node pool"
  default     = "Standard_B2s"
  type        = string
}

variable "vnet_subnet_id" {
  type = string
}
