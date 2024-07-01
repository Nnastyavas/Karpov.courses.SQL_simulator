/*
Задание:
На основе данных в таблице courier_actions для каждого дня рассчитать, за сколько минут в среднем курьеры доставляли свои заказы.

Пояснение:
Некоторые заказы оформляют в один день, а доставляют уже на следующий. 
При расчёте среднего времени доставки в качестве дней, для которых считать среднее, использовать дни фактической доставки заказов.
*/

SELECT
	date,
	round(avg(time_to_deliver))::int AS minutes_to_deliver
FROM
	(
	SELECT
		order_id,
		max(time::date) AS date,
		EXTRACT(epoch
	FROM
		max(time) - min(time)) / 60 AS time_to_deliver
	FROM
		courier_actions
	WHERE
		order_id NOT IN (
		SELECT
			order_id
		FROM
			user_actions
		WHERE
			ACTION = 'cancel_order')
	GROUP BY
		order_id) ca
GROUP BY
	date
ORDER BY
	date