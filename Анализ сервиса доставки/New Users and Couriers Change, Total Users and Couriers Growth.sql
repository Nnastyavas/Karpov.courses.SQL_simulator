/*
Посчитаем динамику показателей в относительных величинах.

Задание:
Для каждого дня, представленного в таблицах user_actions и courier_actions, дополнительно рассчитать следующие показатели:
- Прирост числа новых пользователей.
- Прирост числа новых курьеров.
- Прирост общего числа пользователей.
- Прирост общего числа курьеров.
Показатели, рассчитанные на предыдущем задании (New Users and Couriers, Total Users and Couriers), также включить в результирующую таблицу.
*/

SELECT
	date,
	new_users,
	new_couriers,
	total_users,
	total_couriers,
	round((new_users - LAG(new_users) OVER(
	ORDER BY date))::decimal / LAG(new_users) OVER(
	ORDER BY date) * 100.0,
	2) AS new_users_change,
	round((new_couriers - LAG(new_couriers) OVER(
	ORDER BY date))::decimal / LAG(new_couriers) OVER(
	ORDER BY date) * 100,
	2) AS new_couriers_change,
	round((total_users - LAG(total_users) OVER(
	ORDER BY date))::decimal / LAG(total_users) OVER(
	ORDER BY date) * 100,
	2) AS total_users_growth,
	round((total_couriers - LAG(total_couriers) OVER(
	ORDER BY date))::decimal / LAG(total_couriers) OVER(
	ORDER BY date) * 100,
	2) AS total_couriers_growth
FROM
	(
	SELECT
		date,
		new_users,
		new_couriers,
		sum(new_users) OVER(
		ORDER BY date)::int AS total_users,
		sum(new_couriers) OVER(
		ORDER BY date)::int AS total_couriers
	FROM
		(
		SELECT
			count(user_id) AS new_users,
			date
		FROM
			(
			SELECT
				min(time::date) AS date,
				user_id
			FROM
				user_actions
			GROUP BY
				user_id) ua
		GROUP BY
			date) ua2
	JOIN 
(
		SELECT
			count(courier_id) AS new_couriers,
			date
		FROM
			(
			SELECT
				min(time::date) AS date,
				courier_id
			FROM
				courier_actions
			GROUP BY
				courier_id) ca
		GROUP BY
			date) ca2
			USING(date)
	ORDER BY
		date) t
