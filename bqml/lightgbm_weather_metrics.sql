CREATE OR REPLACE MODEL weather_metrics_data.modelo_lightgbm
OPTIONS(
  model_type='BOOSTED_TREE_REGRESSOR',
  input_label_cols=['qtd_reclamacoes_recebidas'],
  num_parallel_tree=3,
  max_iterations=50,
  learn_rate=0.1
) AS
SELECT
  qtd_reclamacoes_recebidas,
  temperatura_diaria,
  precipitacao_diaria,
  ano,
  mes
FROM
  weather_metrics_data.weather_metrics;
