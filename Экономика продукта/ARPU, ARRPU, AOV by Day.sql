/*
На основе данных о выручке рассчитаем несколько относительных показателей, которые покажут, сколько в среднем потребители готовы платить за услуги нашего сервиса доставки.

Задание:
Для каждого дня в таблицах orders и user_actions рассчитать следующие показатели:
-  Выручку на пользователя (ARPU) за текущий день.
-  Выручку на платящего пользователя (ARPPU) за текущий день.
-  Выручку с заказа, или средний чек (AOV) за текущий день.

Пояснение: 
Будем считать, что оплата за заказ поступает сразу же после его оформления, т.е. случаи, когда заказ был оформлен в один день, а оплата получена на следующий, возникнуть не могут.
Платящими будем считать тех пользователей, которые в данный день оформили хотя бы один заказ, который в дальнейшем не был отменен.
*/

SELECT
	date,
	round(revenue / users,
	2) AS arpu,
	round(revenue / paying_users,
	2) AS arppu,
	round(revenue / orders,
	2) AS aov
FROM
	(
	SELECT
		time::date AS date,
		count(DISTINCT user_id) AS users,
		count(DISTINCT user_id) FILTER(
		WHERE order_id NOT IN (
		SELECT
			order_id
		FROM
			user_actions
		WHERE
			ACTION = 'cancel_order')) AS paying_users,
		count(DISTINCT order_id) FILTER(
		WHERE order_id NOT IN (
		SELECT
			order_id
		FROM
			user_actions
		WHERE
			ACTION = 'cancel_order')) AS orders
	FROM
		user_actions ua
	GROUP BY
		date) t1
JOIN 
(
	SELECT
		date,
		sum(price) AS revenue
	FROM
		(
		SELECT
			creation_time::date AS date,
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
	LEFT JOIN products p
			USING(product_id)
	GROUP BY
		date) t2
		USING(date)
ORDER BY
	date