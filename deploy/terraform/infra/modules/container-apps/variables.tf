variable "managed_environment_name" {
  type        = string
  description = "(Required) Specifies the name of the managed environment."
}

variable "resource_group_id" {
  type        = string
  description = "Id of the resource group"
}

variable "location" {
  type        = string
  description = "The location for the deployment"
}

variable "tags" {
  type = map(any)
}

variable "instrumentation_key" {
  description = "(Optional) Specifies the instrumentation key of the application insights resource."
  type        = string
}

variable "workspace_id" {
  description = "(Optional) Specifies workspace id of the log analytics workspace."
  type        = string
}

variable "primary_shared_key" {
  description = "(Optional) Specifies the workspace key of the log analytics workspace."
  type        = string
}

variable "container_apps" {
  type = list(object({
    name = string
    configuration = object({
      ingress = optional(object({
        external   = optional(bool)
        targetPort = optional(number)
      }))
      dapr = optional(object({
        enabled     = optional(bool)
        appId       = optional(string)
        appProtocol = optional(string)
        appPort     = optional(number)
      }))
    })
    template = object({
      containers = list(object({
        image = string
        name  = string
        env = optional(list(object({
          name  = string
          value = string
        })))
        resources = optional(object({
          cpu    = optional(number)
          memory = optional(string)
        }))
      }))
      scale = optional(object({
        minReplicas = optional(number)
        maxReplicas = optional(number)
      }))
    })
  }))
}
