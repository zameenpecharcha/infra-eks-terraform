resource "kubernetes_service" "auth" {
  metadata {
    name      = "auth-service"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }
  spec {
    selector = {
      app = "auth"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
