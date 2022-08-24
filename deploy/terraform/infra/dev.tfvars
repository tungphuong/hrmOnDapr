environment = "dev"

postgres = {
  base_name             = "default-db"
  version               = "13"
  zone                  = "1"
  storage_mb            = 32768
  sku_name              = "B_Standard_B1ms"
  backup_retention_days = 7
  password              = "P@ssw0rd"
  login                 = "hrmadmin"
  databases = {
    "adminDb" : {
      name      = "adminDb"
      collation = "en_US.utf8"
      charset   = "utf8"
    }
  }
}

application_insights = {
  base_name        = "hrmOnDapr"
  application_type = "web"
}

log_analytics = {
  base_name = "hrmOnDapr"
  sku       = "PerGB2018"
}

aks = {
  base_name          = "hrmOnDapr"
  kubernetes_version = "1.23.8"
}

aks_resources = {
  namespace = "dev"
}

container_apps = {
  managed_environment_name = "managed-env-container-apps"
  apps = [{
    name = "communication"
    configuration = {
      ingress = {
        external   = false
        targetPort = 5101
      }
      dapr = {
        enabled     = true
        appId       = "communication"
        appProtocol = "http"
        appPort     = 5101
      }
    }
    template = {
      containers = [{
        name  = "communication"
        image = "ghcr.io/tungphuong/communication.api:latest"
        resources = {
          cpu    = 0.25
          memory = "0.5Gi"
        }
      }]
    }
    },
    {
      name = "admin"
      configuration = {
        ingress = {
          external   = false
          targetPort = 5100
        }
        dapr = {
          enabled     = true
          appId       = "admin"
          appProtocol = "http"
          appPort     = 5100
        }
      }
      template = {
        containers = [{
          name  = "communication"
          image = "ghcr.io/tungphuong/admin.api:latest"
          resources = {
            cpu    = 0.25
            memory = "0.5Gi"
          }
        }]
      }
    },
    {
      name = "employee-management"
      configuration = {
        ingress = {
          external   = false
          targetPort = 5102
        }
        dapr = {
          enabled     = true
          appId       = "employee-management"
          appProtocol = "http"
          appPort     = 5102
        }
      }
      template = {
        containers = [{
          name  = "employee-management"
          image = "ghcr.io/tungphuong/employee-management.api:latest"
          resources = {
            cpu    = 0.25
            memory = "0.5Gi"
          }
        }]
      }
    },
    {
      name = "api-gateway"
      configuration = {
        ingress = {
          external   = true
          targetPort = 5102
        }
        dapr = {
          enabled     = true
          appId       = "api-gateway"
          appProtocol = "http"
          appPort     = 5102
        }
      }
      template = {
        containers = [{
          name  = "api-gateway"
          image = "ghcr.io/tungphuong/gateway.api:latest"
          resources = {
            cpu    = 0.25
            memory = "0.5Gi"
          }
          env = [{
            name  = "ASPNETCORE_ENVIRONMENT"
            value = "Development"
          }]
        }]
      }
  }]
}
