variable "environment" {
  default = ""
}

variable "az_setting" {
  type = object({
    rg_base_name      = string
    location          = string
    network_base_name = string
  })
  default = {
    location          = "eastus"
    rg_base_name      = "hrmOnDapr"
    network_base_name = "hrmOnDapr"
  }
}

variable "postgres" {
  type = object({
    base_name             = string
    version               = string
    login                 = string
    password              = string
    zone                  = string
    storage_mb            = number
    sku_name              = string
    backup_retention_days = number
    databases = map(object({
      name      = string
      collation = string
      charset   = string
    }))
  })
}

variable "application_insights" {
  type = object({
    base_name        = string
    application_type = string
  })
}

variable "log_analytics" {
  type = object({
    base_name = string
    sku       = string
  })
  validation {
    condition     = contains(["Free", "Standalone", "PerNode", "PerGB2018"], var.log_analytics.sku)
    error_message = "The log analytics sku is incorrect."
  }
}

variable "aks" {
  type = object({
    base_name          = string
    kubernetes_version = string
    node_count         = number
  })
}

variable "aks_resources" {
  type = object({
    namespace         = string
    redis_password    = string
    rabbitmq_user     = string
    rabbitmq_password = string
  })
}

variable "container_apps" {
  type = object({
    managed_environment_name = string
    apps = list(object({
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
  })
}

variable "default_tags" {
  default = {
    environment = "dev"
    version     = "1.0"
  }
}

