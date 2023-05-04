data "google_secret_manager_secret_version_access" "discord_monitoring_webhook_url" {
  secret  = "discord_monitoring_webhook_url"
  version = "latest"
}