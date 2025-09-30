resource "kubernetes_secret" "api_credentials" {
  metadata {
    name      = "api-credentials"
    namespace = kubernetes_namespace.api.metadata[0].name
  }
  data = {
    DB_USER     = "your_db_user"
    DB_PASSWORD = "your_db_password"
    API_KEY     = "your_api_key"
  }
}
