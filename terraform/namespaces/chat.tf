resource "kubernetes_namespace" "chat" {
  metadata {
    name = "chat"
  }
}
