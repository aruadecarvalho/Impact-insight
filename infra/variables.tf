variable "gcp_project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "southamerica-east1"
}

variable "bucket_name" {
  type = string
}

variable "terraform_sa_email" {
  type = string
}

variable "weather_api_key" {
  type = string
}
