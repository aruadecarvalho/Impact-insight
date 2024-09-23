variable "gcp_project_id" {
  type = string
}

variable "location" {
  type = string
}

variable "csv_file_name" {
  default = "weather_stations_temp_precip.csv"
}

variable "csv_file_folder" {
  default = "csv"
}

variable "bucket_name" {
  type = string
}


