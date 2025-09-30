resource "kubernetes_secret" "post_credentials" {
  metadata {
    name      = "post-credentials"
    namespace = kubernetes_namespace.post.metadata[0].name
  }
  data = {
    DB_USER     = "your_db_user"
    DB_PASSWORD = "your_db_password"
    API_KEY     = "your_api_key"
  }
}
