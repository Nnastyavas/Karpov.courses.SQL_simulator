/*
Задание:
На основе данных в таблице user_actions рассчитать показатель дневного Retention для всех пользователей, разбив их на когорты по дате первого взаимодействия с нашим приложением.
*/


SELECT
	date_trunc('month',
	start_date)::date AS start_month,
	start_date,
	dt - start_date AS day_number,
	round(count(DISTINCT user_id)::decimal / max(count(DISTINCT user_id)) OVER(PARTITION BY start_date),
	2) AS retention
FROM
	(
	SELECT
		user_id,
		time::date AS dt,
		min(time::date) OVER(PARTITION BY user_id) AS start_date
	FROM
		user_actions) t1
GROUP BY
	dt,
	start_date
ORDER BY
	start_date,
	day_number