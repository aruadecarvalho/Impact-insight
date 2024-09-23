CREATE OR REPLACE MODEL weather_metrics_data.modelo_arima_precipitacao
OPTIONS(
  model_type='ARIMA_PLUS', 
  time_series_timestamp_col='data',
  time_series_data_col='Precipitacao_diaria'
) AS
SELECT
  DATE(CAST(Ano AS INT64), CAST(Mes AS INT64), 1) AS data,
  Precipitacao_diaria
FROM
  weather_metrics_data.weather_metrics;