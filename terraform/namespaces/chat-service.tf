resource "kubernetes_service" "chat" {
  metadata {
    name      = "chat-service"
    namespace = kubernetes_namespace.chat.metadata[0].name
  }
  spec {
    selector = {
      app = "chat"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
