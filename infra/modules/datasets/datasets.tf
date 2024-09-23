resource "google_bigquery_dataset" "weather_metrics_dataset" {
  project    = var.gcp_project_id
  dataset_id = var.dataset_id
  location   = var.region
}

resource "google_bigquery_table" "weather_metrics_table" {
  project             = var.gcp_project_id
  dataset_id          = google_bigquery_dataset.weather_metrics_dataset.dataset_id
  table_id            = var.table_id
  deletion_protection = false

  external_data_configuration {
    autodetect    = true
    source_uris   = ["gs://${var.bucket_id}/${var.object_name}"]
    source_format = "CSV"
    csv_options {
      quote             = "\""
      field_delimiter   = ";"
      skip_leading_rows = 1
    }
  }
}
