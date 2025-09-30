resource "kubernetes_service" "user" {
  metadata {
    name      = "user-service"
    namespace = kubernetes_namespace.user.metadata[0].name
  }
  spec {
    selector = {
      app = "user"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
