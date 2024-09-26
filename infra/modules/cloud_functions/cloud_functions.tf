resource "google_storage_bucket" "cloud_function_bucket" {
  name     = "cloud-function-${var.gcp_project_id}"
  location = var.region
  project  = var.gcp_project_id
}

resource "google_project_service" "cloudfunction_api" {
  service            = "cloudfunctions.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "artifactregistry_api" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "cloudbuild_api" {
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/function.zip"
}

resource "google_storage_bucket_object" "function_zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.cloud_function_bucket.name
  depends_on = [
    google_storage_bucket.cloud_function_bucket,
    data.archive_file.source
  ]
}

resource "google_cloudfunctions_function" "get_weather_metrics_function" {
  name        = "pull_weather_metrics_and_publish"
  description = "Get real-time weather metrics from weather API"
  runtime     = "python312"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.cloud_function_bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name
  trigger_http          = true
  entry_point           = "pull_weather_metrics_and_publish"
  environment_variables = {
    weather_api_key = var.weather_api_key
  }
  depends_on = [google_project_service.cloudfunction_api, google_project_service.artifactregistry_api, google_project_service.cloudbuild_api]
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.get_weather_metrics_function.project
  region         = google_cloudfunctions_function.get_weather_metrics_function.region
  cloud_function = google_cloudfunctions_function.get_weather_metrics_function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${var.terraform_sa_email}"
}
