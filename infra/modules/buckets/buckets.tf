resource "google_storage_bucket" "weather_metrics_bucket" {
 name          = var.bucket_name
 location      = var.location
 storage_class = "STANDARD"
}

resource "google_storage_bucket_object" "weather_metrics" {
 name         = var.csv_file_name
 source       = "${path.module}/${var.csv_file_folder}/${var.csv_file_name}"
 bucket       = google_storage_bucket.weather_metrics_bucket.id
}