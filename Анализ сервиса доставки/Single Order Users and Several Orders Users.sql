/*
Выясним, как много платящих пользователей совершают более одного заказа в день.

Задание:
Для каждого дня, представленного в таблице user_actions, рассчитать следующие показатели:
- Долю пользователей, сделавших в этот день всего один заказ, в общем количестве платящих пользователей.
- Долю пользователей, сделавших в этот день несколько заказов, в общем количестве платящих пользователей.
*/

SELECT
	date,
	round(single_order_users / (single_order_users + several_orders_users)::decimal * 100,
	2) AS single_order_users_share,
	round(several_orders_users / (single_order_users + several_orders_users)::decimal * 100,
	2) AS several_orders_users_share
FROM
	(
	SELECT
		count(DISTINCT user_id) FILTER(
		WHERE orders_count = 1) AS single_order_users,
		count(DISTINCT user_id) FILTER(
		WHERE orders_count > 1) AS several_orders_users,
		date
	FROM
		(
		SELECT
			count(order_id) AS orders_count,
			user_id,
			time::date AS date
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
			date,
			user_id) t
	GROUP BY
		date) t2