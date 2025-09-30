resource "kubernetes_secret" "auth_credentials" {
  metadata {
    name      = "auth-credentials"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }
  data = {
    DB_USER     = "your_db_user"
    DB_PASSWORD = "your_db_password"
    API_KEY     = "your_api_key"
  }
}
