resource "kubernetes_service" "post" {
  metadata {
    name      = "post-service"
    namespace = kubernetes_namespace.post.metadata[0].name
  }
  spec {
    selector = {
      app = "post"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
