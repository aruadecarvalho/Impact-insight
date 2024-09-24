CREATE OR REPLACE MODEL weather_metrics_data.modelo_arima_temperatura
OPTIONS(
  model_type='ARIMA_PLUS', 
  time_series_timestamp_col='data',
  time_series_data_col='temperatura_diaria'
) AS
SELECT
  DATE(CAST(ano AS INT64), CAST(mes AS INT64), 1) AS data,
  temperatura_diaria
FROM
  weather_metrics_data.weather_metrics;