/*
Отдельно посчитаем ежедневную выручку с заказов новых пользователей нашего сервиса. Посмотрим, какую долю она составляет в общей выручке с заказов всех пользователей — и новых, и старых.

Задание:
Для каждого дня в таблицах orders и user_actions рассчитать следующие показатели:
-  Выручку, полученную в этот день.
-  Выручку с заказов новых пользователей, полученную в этот день.
-  Долю выручки с заказов новых пользователей в общей выручке, полученной за этот день.
-  Долю выручки с заказов остальных пользователей в общей выручке, полученной за этот день.
*/

WITH order_price AS (
SELECT
	date,
	order_id,
	sum(price) AS ord_price
FROM
	(
	SELECT
		creation_time::date AS date,
		order_id,
		UNNEST(product_ids) AS product_id
	FROM
		orders
	WHERE
		order_id NOT IN (
		SELECT
			order_id
		FROM
			user_actions
		WHERE
			ACTION = 'cancel_order')) o
JOIN products p
		USING(product_id)
GROUP BY
	date,
	order_id
)
--
SELECT date, sum(ord_price) AS revenue, new_users_revenue,
round(new_users_revenue / sum(ord_price) * 100,
2) AS new_users_revenue_share,
round((1 -new_users_revenue / sum(ord_price)) * 100,
2) AS old_users_revenue_share
FROM
order_price
JOIN 
(
SELECT
	date,
	sum(ord_price) AS new_users_revenue
FROM
	order_price
JOIN user_actions ua
		USING(order_id)
JOIN (
	SELECT
		user_id,
		min(time)::date AS date
	FROM
		user_actions ua
	GROUP BY
		user_id) t2
		USING(user_id,
	date)
GROUP BY
	date) op
	USING(date)
GROUP BY
date,
new_users_revenue
ORDER BY
date
