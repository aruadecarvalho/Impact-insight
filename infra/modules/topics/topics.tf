locals {
  google_pubsub_sa_email     = var.gcp_pubsub_sa_email
  weather_metrics_table_id   = var.weather_metrics_table_id
  weather_metrics_dataset_id = var.weather_metrics_dataset_id
}

resource "google_pubsub_schema" "weather_metrics_data_schema" {
  name       = "weather_metrics_data_schema"
  type       = "AVRO"
  definition = file("${path.module}/weather_metrics_data_schema_2.json")
}

resource "google_pubsub_topic" "pubsub_weather_metrics" {
  project = var.gcp_project_id
  name    = "pubsub_weather_metrics"

  depends_on = [google_pubsub_schema.weather_metrics_data_schema]
  schema_settings {
    schema   = "projects/${var.gcp_project_id}/schemas/${google_pubsub_schema.weather_metrics_data_schema.name}"
    encoding = "JSON"
  }
}

resource "google_project_service" "dataflow_api" {
  service            = "dataflow.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "bigquery_api" {
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "pubsub_api" {
  service            = "pubsub.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_iam_member" "pubsub_sa_create_oidc_token" {
  project    = var.gcp_project_id
  role       = "roles/iam.serviceAccountTokenCreator"
  member     = "serviceAccount:${local.google_pubsub_sa_email}"
  depends_on = [google_project_service.pubsub_api]
}
resource "google_project_iam_member" "pubsub_editor" {
  project    = var.gcp_project_id
  role       = "roles/pubsub.editor"
  member     = "serviceAccount:${local.google_pubsub_sa_email}"
  depends_on = [google_project_iam_member.pubsub_sa_create_oidc_token]
}
resource "google_project_iam_member" "bigquery_data_editor" {
  project    = var.gcp_project_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${local.google_pubsub_sa_email}"
  depends_on = [google_project_iam_member.pubsub_sa_create_oidc_token]
}

resource "google_pubsub_subscription" "sub_bq_weather_metrics" {
  project = var.gcp_project_id
  name    = "sub_bq_weather_metrics"
  topic   = google_pubsub_topic.pubsub_weather_metrics.name
  bigquery_config {
    table            = "${var.gcp_project_id}.${local.weather_metrics_dataset_id}.${local.weather_metrics_table_id}"
    use_topic_schema = true
  }
  depends_on = [google_project_iam_member.pubsub_editor, google_project_iam_member.bigquery_data_editor]
}

