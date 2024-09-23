output "bucket_id" {
  value = google_storage_bucket.weather_metrics_bucket.id
}

output "weather_metrics_object_name" {
  value = google_storage_bucket_object.weather_metrics.name
}