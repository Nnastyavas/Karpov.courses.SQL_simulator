/*
Попробуем примерно оценить нагрузку на  курьеров и узнаем, сколько в среднем заказов и пользователей приходится на каждого из них.

Задание:
На основе данных в таблицах user_actions, courier_actions и orders для каждого дня рассчитать следующие показатели:
- Число платящих пользователей на одного активного курьера.
- Число заказов на одного активного курьера.
*/

SELECT
	date,
	round(paying_users / active_couriers::decimal,
	2) AS users_per_courier,
	round(orders_cnt / active_couriers::decimal,
	2) AS orders_per_courier
FROM
	(
	SELECT
		count(DISTINCT courier_id) AS active_couriers,
		time::date AS date
	FROM
		courier_actions
	WHERE
		order_id IN (
		SELECT
			order_id
		FROM
			courier_actions
		WHERE
			ACTION = 'deliver_order')
	GROUP BY
		date) ca
LEFT JOIN 
(
	SELECT
		count(DISTINCT user_id) AS paying_users,
		time::date AS date
	FROM
		user_actions
	WHERE
		order_id NOT IN (
		SELECT
			order_id
		FROM
			user_actions
		WHERE
			ACTION = 'cancel_order')
	GROUP BY
		date) ua
		USING(date)
LEFT JOIN 
(
	SELECT
		count(DISTINCT order_id) AS orders_cnt,
		creation_time::date AS date
	FROM
		orders
	WHERE
		order_id NOT IN (
		SELECT
			order_id
		FROM
			user_actions ua
		WHERE
			ACTION = 'cancel_order')
	GROUP BY
		date) o
		USING(date)
ORDER BY
	date