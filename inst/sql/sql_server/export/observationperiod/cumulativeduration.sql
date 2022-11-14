SELECT 'Length of observation' AS series_name,
	ar1.stratum_1 * 30 AS x_length_of_observation,
	round(1.0 * sum(ar2.count_value) / denom.count_value, 5) AS y_percent_persons
FROM (
	SELECT analysis_id,
		cast(stratum_1 AS BIGINT) stratum_1
	FROM @results_database_schema.achilles_results
	WHERE analysis_id = 108
	GROUP BY analysis_id,
		stratum_1
	) ar1
INNER JOIN (
	SELECT analysis_id,
		cast(stratum_1 AS BIGINT) stratum_1,
		count_value
	FROM @results_database_schema.achilles_results
	WHERE analysis_id = 108
	GROUP BY analysis_id,
		stratum_1,
		count_value
	) ar2 ON ar1.analysis_id = ar2.analysis_id
	AND ar1.stratum_1 <= ar2.stratum_1,
	(
		SELECT count_value
		FROM @results_database_schema.achilles_results
		WHERE analysis_id = 1
		) denom
GROUP BY ar1.stratum_1,
	denom.count_value
ORDER BY ar1.stratum_1 * 30 ASC;
