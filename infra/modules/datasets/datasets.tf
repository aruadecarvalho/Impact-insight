module "buckets" {
  source = "../buckets"
}

resource "google_bigquery_dataset" "weather_metrics_dataset" {
  project    = var.project_id
  dataset_id = var.dataset_id
  location   = var.location
}

resource "google_bigquery_table" "weather_metrics_table" {
  project = var.project_id
  dataset_id          = google_bigquery_dataset.weather_metrics_dataset.dataset_id
  table_id            = "weather_metrics"
  deletion_protection = false


  external_data_configuration {
    autodetect    = true
    source_uris   = ["gs://${module.buckets.bucket_id}/${module.buckets.weather_metrics_object_name}"]
    source_format = "CSV"
    csv_options {
      quote = "\""
      field_delimiter = ";"
      skip_leading_rows = 1
    }
  }
}
