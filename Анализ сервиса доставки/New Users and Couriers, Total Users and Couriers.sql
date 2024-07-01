/*
Анализ того, насколько быстро растёт аудитория сервиса. 

Задание:
Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитать следующие показатели:
- Число новых пользователей.
- Число новых курьеров.
- Общее число пользователей на текущий день.
- Общее число курьеров на текущий день.

Пояснение: 
Новыми считаются пользователей и курьеров, которые в данный день совершили своё первое действие в сервисе. 
Общее число пользователей/курьеров на текущий день — это результат сложения числа новых пользователей/курьеров в текущий день со значениями аналогичного показателя всех предыдущих дней.
*/

SELECT
	date,
	new_users,
	new_couriers,
	sum(new_users) OVER(
	ORDER BY date)::int AS total_users,
	sum(new_couriers) OVER(
	ORDER BY date)::int AS total_coriers
FROM
	(
	SELECT
		count(user_id) AS new_users,
		date
	FROM
		(
		SELECT
			min(time::date) AS date,
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
		count(courier_id) AS new_couriers,
		date
	FROM
		(
		SELECT
			min(time::date) AS date,
			courier_id
		FROM
			courier_actions
		GROUP BY
			courier_id) ca
	GROUP BY
		date) ca2
		USING(date)
ORDER BY
	date