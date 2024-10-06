# Power Outage Prediction Pipeline

## Project Goal

This project implements an end-to-end data pipeline on Google Cloud Platform (GCP) that leverages historical weather data (precipitation and temperature) to predict power outages complaints across the state of São Paulo. The pipeline is designed to:

1. Ingest historical weather data from a CSV file and populate a BigQuery table.
2. Periodically pull real-time weather data from an external API via a Cloud Function, triggered by Cloud Scheduler.
3. Pass the real-time data through Pub/Sub into BigQuery for continuous analysis.
4. Use BigQuery ML (BQML) to train two models:
    - **ARIMA** for forecasting weather (precipitation and temperature).
    - **LightGBM** for predicting power outages based on weather conditions.
5. Visualize the results and predictions through a Looker Studio dashboard.

## Pipeline Overview

1. **Batch Process**: Initial ingestion of historical weather data from a CSV into BigQuery.
2. **Streaming Process**: Regular ingestion of real-time weather data using Cloud Functions and Pub/Sub.
3. **Machine Learning**: BQML is used to train and predict power outages using weather data.
4. **Visualization**: Power outages predictions are visualized using Looker Studio.

## Project Structure

```
/bqml
  ├── arima_*.sql                          # ARIMA model script for weather data forecasting
  ├── lightgbm_weather_metrics.sql         # LightGBM model script for predicting power outages

/infra
  ├── main.tf                      # Main Terraform configuration file
  ├── variables.tf                 # Variable definitions for Terraform
  ├── example.tfvars               # Example of the variables neeeded to run the infrastructure
```

## Data Ingestion Process

![image](https://github.com/user-attachments/assets/3b7446c6-6786-465b-9566-6d79110df100)

1. **Batch Ingestion**: The pipeline starts with ingesting historical weather data from a CSV file, which contains data related to precipitation, temperature, and power outages complaints across the state of São Paulo. This data is loaded into BigQuery for training purposes.
   
2. **Streaming Ingestion**: A GCP Cloud Function, triggered by Cloud Scheduler, is responsible for periodically pulling real-time weather data from an external API. This data is sent to a Pub/Sub topic, which in turn inserts the data into BigQuery for continuous model predictions.

## Machine Learning Models

- **ARIMA Model**: This model forecasts future weather conditions (precipitation and temperature) based on historical data.
  
- **LightGBM Model**: This model predicts the number of power outage complaints, based on the weather forecasts (precipitation and temperature), and feeds these predictions back into the pipeline for analysis.

## Infrastructure Deployment

The infrastructure for this project is provisioned using Terraform. It sets up the necessary GCP resources such as BigQuery, Cloud Functions, Pub/Sub, and Cloud Scheduler.

### Terraform Variables

To deploy the infrastructure, you'll need to set the following variables in your `.tfvars` file:
```hcl

gcp_project_id     = "<PROJECT_ID>"
region             = "<REGION>"
bucket_name        = "<BUCKET_NAME>"
terraform_sa_email = "<TERRAFORM_SA_EMAIL>"
weather_api_key    = "<WEATHER_API_KEY>"
```

## Visualizing the Data

Once the pipeline is set up and running, data predictions and insights are visualized using Looker Studio. The dashboard provides a real-time view of predicted power outages and allows users to track correlations between weather conditions and service complaints.

## How to Run the Project

### Prerequisites

- Google Cloud Platform account.
- Terraform installed on your local machine.
- Access to Looker Studio for data visualization.

### Steps

1. **Set up Infrastructure**:
    - Clone the repository.
    - Navigate to the `/infra` folder.
    - Fill in the necessary variables in your `.tfvars` file.
    - Run `terraform init` to initialize the project.
    - Run `terraform apply` to deploy the infrastructure.

2. **Ingest Data**:
    - Place the historical weather data CSV in the configured GCS bucket.
    - Run the initial ingestion script to populate BigQuery with historical data.

3. **Set Up Cloud Functions and Scheduler**:
    - Deploy the Cloud Function to pull real-time data from the external API.
    - Set up Cloud Scheduler to trigger the function periodically.

4. **Train and Use Models**:
    - Use the scripts in `/bqml` to train the ARIMA and LightGBM models in BigQuery.
    - Predictions from the models will be stored in BigQuery tables and can be accessed for further analysis.

5. **Visualize Data**:
    - Connect BigQuery tables to Looker Studio to create a dashboard.
    - Monitor real-time power outage predictions based on weather data.

## Future Enhancements

- Extend the pipeline to support additional regions beyond São Paulo.
- Enhance the machine learning model by incorporating more features or using alternative algorithms.
- Improve visualization with more detailed insights and breakdowns.
