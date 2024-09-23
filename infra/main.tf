terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.region
}

data "google_project" "project" {}
data "google_client_config" "google_client" {}

locals {
  gcp_project_number  = data.google_project.project.number
  gcp_pubsub_sa_email = "service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

module "buckets" {
  source         = "./modules/buckets"
  gcp_project_id = var.gcp_project_id
  location       = var.region
  bucket_name    = var.bucket_name
}

module "datasets" {
  source         = "./modules/datasets"
  bucket_id      = module.buckets.bucket_id
  object_name    = module.buckets.weather_metrics_object_name
  region         = var.region
  gcp_project_id = var.gcp_project_id
  depends_on     = [module.buckets]
}

module "topics" {
  source                     = "./modules/topics"
  weather_metrics_dataset_id = module.datasets.weather_metrics_dataset_id
  weather_metrics_table_id   = module.datasets.weather_metrics_table_id
  gcp_pubsub_sa_email        = local.gcp_pubsub_sa_email
  gcp_project_number         = local.gcp_project_number
  gcp_project_id             = var.gcp_project_id
  depends_on                 = [module.datasets]
}
