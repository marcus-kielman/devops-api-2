terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

provider "kubernetes" {
  host = var.host

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}
resource "kubernetes_deployment" "devops-api" {
  metadata {
    name = "devops-api"
    labels = {
      App = "devops-api"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        App = "devops-api"
      }
    }
    template {
      metadata {
        labels = {
          App = "devops-api"
        }
      }
      spec {
        container {
          image = "marcuskielman/devops_api:latest"
          name  = "devops-api"

          port {
            container_port = 8081
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "devops-api" {
  metadata {
    name = "devops-api"
  }
  spec {
    selector = {
      App = kubernetes_deployment.devops-api.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 9090
      target_port = 8081
    }

    type = "NodePort"
  }
}
