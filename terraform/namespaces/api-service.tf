resource "kubernetes_service" "api" {
  metadata {
    name      = "api-service"
    namespace = kubernetes_namespace.api.metadata[0].name
  }
  spec {
    selector = {
      app = "api"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
