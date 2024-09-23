variable "bucket_id" {
  type = string
}

variable "object_name" {
  type = string
}

variable "region" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "table_id" {
  default = "weather_metrics"
}

variable "dataset_id" {
  default = "weather_metrics_data"
}

