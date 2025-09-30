resource "kubernetes_secret" "property_credentials" {
  metadata {
    name      = "property-credentials"
    namespace = kubernetes_namespace.property.metadata[0].name
  }
  data = {
    DB_USER     = "your_db_user"
    DB_PASSWORD = "your_db_password"
    API_KEY     = "your_api_key"
  }
}
