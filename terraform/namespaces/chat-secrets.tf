resource "kubernetes_secret" "chat_credentials" {
  metadata {
    name      = "chat-credentials"
    namespace = kubernetes_namespace.chat.metadata[0].name
  }
  data = {
    DB_USER     = "your_db_user"
    DB_PASSWORD = "your_db_password"
    API_KEY     = "your_api_key"
  }
}
