output "weather_metrics_dataset_id" {
  value = google_bigquery_dataset.weather_metrics_dataset.dataset_id
}

output "weather_metrics_table_id" {
  value = google_bigquery_table.weather_metrics_table.table_id
}