import requests
import json
from google.cloud import pubsub_v1
import datetime
import os

def get_estacoes_sp():
    with open('./estacoes_sp.json') as f:
        data = json.load(f)
    return data

def pull_weather_metrics_and_publish(event):
    estacoes = get_estacoes_sp()
    for estacao in estacoes:
        api_key = os.environ.get("WEATHER_API_KEY")
        api_url = "http://api.weatherapi.com/v1/current.json" + f"?key={api_key}" f"&q={estacao["latitude"]},{estacao["longitude"]}"

        response = requests.get(api_url)
        data = response.json()
        today = datetime.date.today()
        metric_data = {
            "ano": today.year,
            "mes": today.month,
            "precipitacao_diaria": data["current"]["precip_mm"],
            "temperature_diaria": data["current"]["temp_c"],
        }

        message = json.dumps(metric_data)

        publisher = pubsub_v1.PublisherClient()

        project_id = os.environ.get("GCP_PROJECT_ID")
        pub_sub_id = os.environ.get("GCP_PUB_SUB_ID")
        topic_path = publisher.topic_path(project_id, pub_sub_id)
        publisher.publish(topic_path, data=message.encode("utf-8"), origin="weather-data-service")

    return {"message": "ok"}
