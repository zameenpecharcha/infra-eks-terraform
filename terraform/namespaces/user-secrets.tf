resource "kubernetes_secret" "user_credentials" {
  metadata {
    name      = "user-credentials"
    namespace = kubernetes_namespace.user.metadata[0].name
  }
  data = {
    DB_USER     = "your_db_user"
    DB_PASSWORD = "your_db_password"
    API_KEY     = "your_api_key"
  }
}
