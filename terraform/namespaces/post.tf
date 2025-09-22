resource "kubernetes_namespace" "post" {
  metadata {
    name = "post"
  }
}