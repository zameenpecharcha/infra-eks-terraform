resource "kubernetes_service" "property" {
  metadata {
    name      = "property-service"
    namespace = kubernetes_namespace.property.metadata[0].name
  }
  spec {
    selector = {
      app = "property"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
