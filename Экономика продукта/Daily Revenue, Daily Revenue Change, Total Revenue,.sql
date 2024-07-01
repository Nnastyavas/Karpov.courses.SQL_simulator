/*
Начнём с выручки — наиболее общего показателя, который покажет, какой доход приносит наш сервис.

Задание:
Для каждого дня в таблице orders рассчитать следующие показатели:
- Выручку, полученную в этот день.
- Суммарную выручку на текущий день.
- Прирост выручки, полученной в этот день, относительно значения выручки за предыдущий день.

Пояснение: 
Будем считать, что оплата за заказ поступает сразу же после его оформления, т.е. случаи, когда заказ был оформлен в один день, а оплата получена на следующий, возникнуть не могут.
*/

SELECT
	date,
	revenue,
	sum(revenue) OVER(
	ORDER BY date) AS total_revenue,
	round((revenue - LAG(revenue) OVER(
	ORDER BY date)) / (LAG(revenue) OVER(
	ORDER BY date)) * 100,
	2) AS revenue_change
FROM
	(
	SELECT
		date,
		sum(price) AS revenue
	FROM
		(
		SELECT
			order_id,
			creation_time::date AS date,
			UNNEST(product_ids) AS product_id
		FROM
			orders
		WHERE
			order_id NOT IN (
			SELECT
				order_id
			FROM
				user_actions ua
			WHERE
				ACTION = 'cancel_order')) o
	LEFT JOIN products p
			USING(product_id)
	GROUP BY
		date) t
ORDER BY
	date
