resource "kubernetes_pods" "devops-api" {
  metadata {
    name = "devops-api"
    labels = {
      App = "devops-api"
    }
  }

  spec {
    replicas = 5
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
