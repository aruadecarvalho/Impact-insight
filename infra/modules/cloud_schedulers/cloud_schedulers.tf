resource "google_project_service" "bigquery_api" {
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloud_scheduler_job" "get_weather_metrics_job" {
  name        = var.get_weather_metrics_function_name
  description = "Get real-time weather metrics from weather API every hour"
  schedule    = "0 * * * *"
  http_target {
    http_method = "GET"
    uri         = var.get_weather_metrics_function_trigger_url
    oidc_token {
      service_account_email = var.terraform_sa_email
    }
  }
}
