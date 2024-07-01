/*
Также было бы интересно посмотреть, какие товары пользуются наибольшим спросом и приносят нам основной доход.

Задание:
Для каждого товара, представленного в таблице products, за весь период времени в таблице orders рассчитать следующие показатели:
-  Суммарную выручку, полученную от продажи этого товара за весь период.
-  Долю выручки от продажи этого товара в общей выручке, полученной за весь период.

Товары, округлённая доля которых в выручке составляет менее 0.5%, объедините в общую группу с названием «ДРУГОЕ», просуммировав округлённые доли этих товаров.

Пояснение: 
Товары с небольшой долей в выручке необходимо объединить в одну группу, чтобы не выводить на графике абсолютно все товары из таблицы products.
*/


WITH product_revenue AS (
SELECT
	name,
	sum(price) AS revenue
FROM
	(
	SELECT
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
	name)
SELECT
	product_name,
	sum(revenue) AS revenue,
	sum(share_in_revenue) AS share_in_revenue
FROM
	(
	SELECT
		CASE
			WHEN round(revenue / sum(revenue) OVER() * 100,
			2) < 0.5 THEN 'ДРУГОЕ'
			ELSE name
		END AS product_name,
		revenue,
		round(revenue / sum(revenue) OVER() * 100,
		2) AS share_in_revenue
	FROM
		product_revenue) pr
GROUP BY
	product_name
ORDER BY
	revenue DESC