terraform {
  required_version = ">= 1.0"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

data "http" "argocd_url" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

data "kubectl_file_documents" "argocd_manifest" {
  content = data.http.argocd_url.response_body
}

locals {
  namespaces = ["argocd", var.namespace]
}

resource "kubernetes_namespace" "default" {
  for_each = toset(local.namespaces)

  metadata {
    name = each.value
  }
}

resource "kubernetes_config_map" "commonConfig" {
  metadata {
    name      = "common-config-map"
    namespace = var.namespace
  }
  data = {    
    ASPNETCORE_URLS        = "http://0.0.0.0:80"
    ASPNETCORE_ENVIRONMENT = "Development"
  }

  depends_on = [kubernetes_namespace.default]
}

resource "kubernetes_secret" "commonSecret" {
  metadata {
    name      = "common-secret"
    namespace = var.namespace
  }

  data = {
    REDIS_PASSWORD    = var.redis_password
    RABBITMQ_USERNAME = var.rabbitmq_user
    RABBITMQ_PASSWORD = var.rabbitmq_password
    ADMIN_DB_CONNECTION    = "${var.db_connection_string};Database=adminDb"
  }

  type = "kubernetes.io/Opaque"
}

resource "kubectl_manifest" "argocd_apply" {
  for_each           = data.kubectl_file_documents.argocd_manifest.manifests
  yaml_body          = each.value
  override_namespace = "argocd"

  depends_on = [kubernetes_namespace.default]
}

resource "helm_release" "dapr" {
  name             = "dapr"
  repository       = "https://dapr.github.io/helm-charts/"
  chart            = "dapr"
  version          = "1.8"
  create_namespace = true
  wait             = true
}

resource "helm_release" "rabbitmq" {
  name       = "rabbitmq"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  namespace  = var.namespace

  set {
    name  = "auth.username"
    value = var.rabbitmq_user
  }
  set {
    name  = "auth.password"
    value = var.rabbitmq_password
  }
  set {
    name  = "resources.limits.cpu"
    value = "256m"
  }

  set {
    name  = "resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "resources.requests.cpu"
    value = "256m"
  }

  set {
    name  = "resources.requests.memory"
    value = "256Mi"
  }

  wait = true
}

resource "helm_release" "redis" {
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  namespace  = var.namespace
  set {
    name  = "replica.replicaCount"
    value = 1
  }

  set {
    name  = "auth.password"
    value = var.redis_password
  }
  wait = true
}