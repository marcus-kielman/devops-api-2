resource "kubernetes_deployment" "mariadb" {
  metadata {
    name = "mariadb"
    labels = {
      App = "mariadb"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "mariadb"
      }
    }
    template {
      metadata {
        labels = {
          App = "mariadb"
        }
      }
      spec {
        container {
          image = "marcuskielman/mariadb:latest"
          name  = "mariadb"

          port {
            container_port = 3306
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
resource "kubernetes_service" "mariadb" {
  metadata {
    name = "mariadb"
  }
  spec {
    selector = {
      App = kubernetes_deployment.mariadb.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30203
      port        = 3306
      target_port = 3306
    }

    type = "NodePort"
  }
}