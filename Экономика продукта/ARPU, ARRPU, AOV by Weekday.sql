/*
Посчитаем показатели ARPU, ARPPU, AOV, но в другом разрезе — не просто по дням, а по дням недели.

Задание:
Для каждого дня недели в таблицах orders и user_actions рассчитать следующие показатели:
-  Выручку на пользователя (ARPU).
-  Выручку на платящего пользователя (ARPPU).
-  Выручку на заказ (AOV).

При расчётах учитывайте данные только за период с 26 августа 2022 года по 8 сентября 2022 года включительно — так, чтобы в анализ попало одинаковое количество всех дней недели (ровно по два дня).
В результирующую таблицу включите как наименования дней недели (например, Monday), так и порядковый номер дня недели (от 1 до 7, где 1 — это Monday, 7 — это Sunday).

Пояснение: 
Будем считать, что оплата за заказ поступает сразу же после его оформления, т.е. случаи, когда заказ был оформлен в один день, а оплата получена на следующий, возникнуть не могут.
Платящими будем считать тех пользователей, которые в данный день оформили хотя бы один заказ, который в дальнейшем не был отменен.
При расчёте выручки помните, что не все заказы были оплачены — некоторые были отменены пользователями.
В этой задаче порядковый номер дня недели необходим для того, чтобы дни недели были расположены на графике слева направо в правильном порядке — не по возрастанию наименования, а по возрастанию порядкового номера. 
*/

SELECT
	weekday,
	weekday_number,
	round(revenue / users,
	2) AS arpu,
	round(revenue / paying_users,
	2) AS arppu,
	round(revenue / orders,
	2) AS aov
FROM
	(
	SELECT
		sum(price) AS revenue,
		date_part('isodow',
		creation_time) AS weekday_number,
		to_char(creation_time,
		'Day') AS weekday
	FROM
		(
		SELECT
			UNNEST(product_ids) AS product_id,
			creation_time
		FROM
			orders
		WHERE
			order_id NOT IN (
			SELECT
				order_id
			FROM
				user_actions
			WHERE
				ACTION = 'cancel_order')
			AND creation_time BETWEEN '2022-08-26' AND '2022-09-09') o
	JOIN products
			USING(product_id)
	GROUP BY
		weekday_number,
		weekday) t1
JOIN
(
	SELECT
		date_part('isodow',
		time) AS weekday_number,
		to_char(time,
		'Day') AS weekday,
		count(DISTINCT user_id) AS users,
		count(DISTINCT user_id) FILTER(
	WHERE
		order_id NOT IN (
		SELECT
			order_id
		FROM
			user_actions
		WHERE
			ACTION = 'cancel_order')) AS paying_users,
		count(DISTINCT order_id) FILTER(
	WHERE
		order_id NOT IN (
		SELECT
			order_id
		FROM
			user_actions
		WHERE
			ACTION = 'cancel_order')) AS orders
	FROM
		user_actions ua
	WHERE
		time BETWEEN '2022-08-26' AND '2022-09-09'
	GROUP BY
		weekday_number,
		weekday) t2
		USING(weekday_number,
	weekday)
ORDER BY
	weekday_number

