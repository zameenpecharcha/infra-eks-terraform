resource "kubernetes_namespace" "user" {
  metadata {
    name = "user"
  }
}
