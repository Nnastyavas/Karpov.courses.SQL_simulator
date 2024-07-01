/*
Задание:
Для каждого дня, представленного в таблице user_actions, рассчитать следующие показатели:
- Общее число заказов.
- Число первых заказов (заказов, сделанных пользователями впервые).
- Число заказов новых пользователей (заказов, сделанных пользователями в тот же день, когда они впервые воспользовались сервисом).
- Долю первых заказов в общем числе заказов (долю п.2 в п.1).
- Долю заказов новых пользователей в общем числе заказов (долю п.3 в п.1).

Пояснение: 
У каждого пользователя может быть всего один первый заказ (что вполне логично).
В свой первый день каждый новый пользователь мог как совершить сразу несколько заказов, так и не совершить ни одного.
*/

SELECT
	date,
	orders,
	first_orders,
	new_users_orders,
	round(first_orders::decimal / orders * 100,
	2) AS first_orders_share,
	round(new_users_orders::decimal / orders * 100,
	2) AS new_users_orders_share
FROM
	(
	SELECT
		time::date AS date,
		count(order_id) AS orders
	FROM
		user_actions
	WHERE
		order_id NOT IN (
		SELECT
			order_id
		FROM
			user_actions ua
		WHERE
			ACTION = 'cancel_order')
	GROUP BY
		date) t1
LEFT JOIN 
(
	SELECT
		time::date AS date,
		count(order_id) AS first_orders
	FROM
		user_actions ua
	WHERE
		order_id IN (
		SELECT
			DISTINCT FIRST_VALUE(order_id) OVER(PARTITION BY user_id
		ORDER BY
			time) AS m
		FROM
			user_actions ua
		WHERE
			order_id NOT IN (
			SELECT
				order_id
			FROM
				user_actions ua
			WHERE
				ACTION = 'cancel_order'))
	GROUP BY
		date) t2
		USING(date)
LEFT JOIN 
(
	SELECT
		dt2.date,
		sum(COALESCE(cnt, 0))::int AS new_users_orders
	FROM
		(
		SELECT
			user_id,
			min(time)::date AS date
		FROM
			user_actions ua
		GROUP BY
			user_id) dt1
	LEFT JOIN 
(
		SELECT
			count(order_id) AS cnt,
			time::date AS date,
			user_id
		FROM
			user_actions ua
		WHERE
			order_id NOT IN (
			SELECT
				order_id
			FROM
				user_actions ua2
			WHERE
				ACTION = 'cancel_order')
		GROUP BY
			user_id,
			date) dt2
			USING(user_id)
	WHERE
		dt1.date = dt2.date
	GROUP BY
		dt2.date) t3
		USING(date)
ORDER BY
	date
