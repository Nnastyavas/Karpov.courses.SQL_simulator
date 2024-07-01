/*
Вычислим метрики ARPU, ARPPU, AOV, но для каждого дня будем учитывать накопленную выручку и все имеющиеся на текущий момент данные о числе пользователей и заказов. 
Таким образом, получим динамический ARPU, ARPPU и AOV и сможем проследить, как он менялся на протяжении времени с учётом поступающих нам данных.

Задание:
По таблицам orders и user_actions для каждого дня рассчитать следующие показатели:
-  Накопленную выручку на пользователя (Running ARPU).
-  Накопленную выручку на платящего пользователя (Running ARPPU).
-  Накопленную выручку с заказа, или средний чек (Running AOV).

Пояснение: 
При расчёте числа пользователей и платящих пользователей на текущую дату учитывайте соответствующих пользователей за все предыдущие дни, включая текущий.
Платящими будем считать тех пользователей, которые на текущий день оформили хотя бы один заказ, который в дальнейшем не был отменен.
Будем считать, что оплата за заказ поступает сразу же после его оформления, т.е. случаи, когда заказ был оформлен в один день, а оплата получена на следующий, возникнуть не могут.
*/

SELECT
	date,
	round(sum(revenue) OVER(
	ORDER BY date) / sum(users) OVER(
	ORDER BY date),
	2) AS running_arpu,
	round(sum(revenue) OVER(
	ORDER BY date) / sum(paying_users) OVER(
	ORDER BY date),
	2) AS running_arppu,
	round(sum(revenue) OVER(
	ORDER BY date) / sum(orders) OVER(
	ORDER BY date),
	2) AS running_aov
FROM
	(
	SELECT
		date,
		sum(price) AS revenue,
		count(DISTINCT order_id) AS orders
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
	LEFT JOIN products p
			USING(product_id)
	GROUP BY
		date) rvn_ord
JOIN
(
	SELECT
		time::date AS date,
		count(DISTINCT user_id) AS users
	FROM
		(
		SELECT
			user_id,
			min(time) AS time
		FROM
			user_actions
		GROUP BY
			user_id) ua
	GROUP BY
		date) usrs
		USING(date)
JOIN 
(
	SELECT
		date,
		count(user_id) AS paying_users
	FROM
		(
		SELECT
			user_id,
			min(time)::date AS date
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
			user_id) pua1
	GROUP BY
		date) pyusr
		USING(date)
ORDER BY
	date