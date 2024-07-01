/*
Посчитаем ту часть пользователей, которая оформляет и оплачивает заказы в сервисе. Заодно выясним, какую долю платящие пользователи составляют от их общего числа.

Задание:
Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитать следующие показатели:
- Число платящих пользователей.
- Число активных курьеров.
- Долю платящих пользователей в общем числе пользователей на текущий день.
- Долю активных курьеров в общем числе курьеров на текущий день.

Пояснение: 
Платящими будем считать тех пользователей, которые в данный день оформили хотя бы один заказ, который в дальнейшем не был отменен.
Курьеров будем считать активными, если в данный день они приняли хотя бы один заказ, который был доставлен (возможно, уже на следующий день), или доставили любой заказ.
Общее число пользователей/курьеров на текущий день — это по-прежнему результат сложения числа новых пользователей/курьеров в текущий день со значениями аналогичного показателя всех предыдущих дней.
*/

WITH total_uc AS (
SELECT
	date,
	sum(users) OVER(
ORDER BY
	date) AS total_users,
	sum(couriers) OVER(
ORDER BY
	date) AS total_couriers
FROM
	(
	SELECT
		count(user_id) AS users,
		date
	FROM
		(
		SELECT
			min(time)::date AS date,
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
		count(courier_id) AS couriers,
		date
	FROM
		(
		SELECT
			min(time)::date AS date,
			courier_id
		FROM
			courier_actions
		GROUP BY
			courier_id) ca
	GROUP BY
		date) ca2
		USING(date)),
active_uc AS (
SELECT
	*
FROM
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
JOIN 
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
		USING(date))
SELECT
	date,
	paying_users,
	active_couriers,
	round(paying_users / total_users * 100,
	2) AS paying_users_share,
	round(active_couriers / total_couriers * 100,
	2) AS active_couriers_share
FROM
	total_uc
JOIN active_uc
		USING(date)
