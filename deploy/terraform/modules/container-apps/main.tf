terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "0.5.0"
    }
  }
  experiments = [module_variable_optional_attrs]
}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.module_tag)
}

resource "azapi_resource" "managed_environment" {
  name      = "${var.managed_environment_name}-me"
  location  = var.location
  parent_id = var.resource_group_id
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  tags      = local.tags

  body = jsonencode({
    properties = {
      daprAIInstrumentationKey = var.instrumentation_key
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = var.workspace_id
          sharedKey  = var.primary_shared_key
        }
      }
    }
  })

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azapi_resource" "container_app" {
  for_each = { for app in var.container_apps : app.name => app }

  name      = each.key
  location  = var.location
  parent_id = var.resource_group_id
  type      = "Microsoft.App/containerApps@2022-03-01"
  tags      = local.tags

  body = jsonencode({
    properties : {
      managedEnvironmentId = azapi_resource.managed_environment.id
      configuration = {
        ingress = try(each.value.configuration.ingress, null)
        dapr    = try(each.value.configuration.dapr, null)
      }
      template = each.value.template
    }
  })
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
