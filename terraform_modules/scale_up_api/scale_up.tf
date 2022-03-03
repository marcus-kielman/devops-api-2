resource "kubernetes_replication_controller" "devops-api" {
  metadata {
    name = "devops-api"
    labels = {
      test = "devops-api"
    }
  }

  spec {
    selector = {
      test = "devops-api"
    }
    template {
      metadata {
        labels = {
          test = "devops-api"
        }
        annotations = {
          "key1" = "value1"
        }
      }

      spec {
        replicas = 5
        container {
          image = "marcuskielman/devops_api:latest"
          name  = "devops-api"

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
