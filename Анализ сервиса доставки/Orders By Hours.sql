/*
Оценим почасовую нагрузку на сервис, выясним, в какие часы пользователи оформляют больше всего заказов, и заодно проанализируем, как изменяется доля отмен в зависимости от времени оформления заказа.

Задача:
На основе данных в таблице orders для каждого часа в сутках рассчитать следующие показатели:
- Число успешных (доставленных) заказов.
- Число отменённых заказов.
- Долю отменённых заказов в общем числе заказов (cancel rate).
*/

SELECT
	date_part('hour',
	creation_time)::int AS HOUR,
	count(order_id) FILTER(
	WHERE order_id IN (
	SELECT
		order_id
	FROM
		courier_actions
	WHERE
		ACTION = 'deliver_order')) AS successful_orders,
	count(order_id) FILTER(
	WHERE order_id IN (
	SELECT
		order_id
	FROM
		user_actions ua
	WHERE
		ACTION = 'cancel_order')) AS canceled_orders,
	round((count(order_id) FILTER(
	WHERE order_id IN (
	SELECT
		order_id
	FROM
		user_actions ua
	WHERE
		ACTION = 'cancel_order'))) / (count(order_id))::decimal,
	3) AS cancel_rate
FROM
	orders o
GROUP BY
	HOUR
ORDER BY
	HOUR