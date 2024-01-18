-- PIZZA METRICS
-- How many pizzas were ordered?
select count(order_id) as "Number of Pizzas Ordered" from customer_orders;

-- How many unique customer orders were made?
select count(distinct order_id) as "Number of Unique Customer Orders" from customer_orders;

-- How many successful orders were delivered by each runner?
select runner_id, count(order_id) as "Number of Successful Orders" 
from runner_orders
where cancellation is null
group by runner_id;

-- How many of each type of pizza was delivered?
SELECT CAST(n.pizza_name AS VARCHAR(100)),CAST(COUNT(*)AS VARCHAR(100)) as  cantidad_pizzas
FROM customer_orders c 
JOIN pizza_names n 
ON (c.pizza_id = n.pizza_id)
JOIN runner_orders r 
ON (c.order_id = r.order_id)
WHERE r.cancellation IS NULL
GROUP BY CAST(n.pizza_name AS VARCHAR(100))

-- How many Vegetarian and Meatlovers were ordered by each customer?
select c.customer_id, p.pizza_name, count(c.pizza_id) as "Number of Pizzas Ordered"
from customer_orders c
join pizza_names p
on c.pizza_id = p.pizza_id
group by c.customer_id, p.pizza_name
order by c.customer_id;

-- What was the maximum number of pizzas delivered in a single order?
select max(pizza_count) as "Maximum Number of Pizzas Ordered"
from (select order_id, count(pizza_id) as pizza_count
from customer_orders
group by order_id) as pizza_count;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select customer_id, count(order_id) as "Number of Orders with Changes"
from customer_orders
where extras != '' or exclusions != ''
group by customer_id;

SELECT customer_id, count(order_id) AS "Number of Orders with No Changes"
FROM customer_orders
WHERE extras = '' AND exclusions = ''
GROUP BY customer_id;

-- How many pizzas were delivered that had both exclusions and extras?
select count(order_id) as "Number of Orders with Both Extras and Exclusions"
from customer_orders
where extras != '' and exclusions != '';

-- What was the total volume of pizzas ordered for each hour of the day?
SELECT
  CONVERT(DATE, order_time) AS order_date,
  DATEPART(HOUR, order_time) AS order_hour,
  COUNT(*) AS pizzas_ordered
FROM
  customer_orders
GROUP BY
  CONVERT(DATE, order_time),
  DATEPART(HOUR, order_time)
ORDER BY
  order_date, order_hour;

-- What was the volume of orders for each day of the week?
SELECT
  DATENAME(WEEKDAY, order_time) AS order_weekday,
  COUNT(*) AS pizzas_ordered
FROM
    customer_orders
GROUP BY
    DATENAME(WEEKDAY, order_time)
ORDER BY
    pizzas_ordered DESC;


