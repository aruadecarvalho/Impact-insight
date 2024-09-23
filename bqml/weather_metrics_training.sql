-- temperature
SELECT
  *
FROM
  ML.FORECAST(MODEL weather_metrics_data.modelo_arima_temperatura, 
  STRUCT(5 AS horizon, 0.8 AS confidence_level));

-- precipitation
SELECT
  *
FROM
  ML.FORECAST(MODEL weather_metrics_data.modelo_arima_precipitacao, 
  STRUCT(5 AS horizon, 0.8 AS confidence_level));

-- weather metrics data
SELECT
  *
FROM
  ML.PREDICT(MODEL weather_metrics_data.modelo_lightgbm,
  (SELECT
    Temperatura_diaria,
    Precipitacao_diaria
  FROM
    weather_metrics_data.weather_metrics));