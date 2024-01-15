-- What is the total amount each customer spent at the restaurant?

select sales.customer_id, sum(menu.price) as total_spent
from sales 
inner join menu on sales.product_id = menu.product_id
group by customer_id;

-- How many days has each customer visited the restaurant?

select sales.customer_id, COUNT(DISTINCT sales.order_date) as days_visited
from sales
group by customer_id;


-- What was the first item from the menu purchased by each customer?

SELECT customer_id, order_date, t.product_id ,menu.product_name
FROM (
    SELECT sales.customer_id, sales.order_date, sales.product_id,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS row_num
    FROM sales
) t
join menu on t.product_id = menu.product_id
WHERE row_num = 1;

-- What is the most purchased item on the menu and how many times was it purchased by all customers?

select top 1 menu.product_name, count(sales.product_id) as total
from sales
inner join menu on sales.product_id = menu.product_id
group by menu.product_name
order by total desc

-- Which item was the most popular for each customer?

WITH RankedSales AS (
  SELECT
    members.customer_id,
    menu.product_id,
    menu.product_name,
    COUNT(sales.product_id) AS total_purchased,
    ROW_NUMBER() OVER (PARTITION BY members.customer_id ORDER BY COUNT(sales.product_id) DESC) AS rn
  FROM
    sales
    INNER JOIN menu ON sales.product_id = menu.product_id
    INNER JOIN members ON sales.customer_id = members.customer_id
  GROUP BY
    members.customer_id,
    menu.product_id,
    menu.product_name
)
SELECT
  customer_id,
  product_id,
  total_purchased,
  product_name
FROM
  RankedSales
WHERE
  rn = 1;

-- Which item was purchased first by the customer after they became a member?

WITH RankedSales AS (
  SELECT
    members.customer_id,
    menu.product_id,
    menu.product_name,
    sales.order_date,
    ROW_NUMBER() OVER (PARTITION BY members.customer_id ORDER BY sales.order_date) AS rn
  FROM
    sales
    INNER JOIN menu ON sales.product_id = menu.product_id
    INNER JOIN members ON sales.customer_id = members.customer_id
  WHERE
    sales.order_date >= members.join_date
)
select 
customer_id,
product_id,
product_name,
order_date
FROM
    RankedSales
    WHERE
    rn = 1;

-- Which item was purchased just before the customer became a member?

select customer_id, product_id, product_name, order_date
from (
    select 
    members.customer_id,
    menu.product_id,
    menu.product_name,
    sales.order_date,
    ROW_NUMBER() OVER (PARTITION BY members.customer_id ORDER BY sales.order_date desc) AS rn
    from sales
    inner join menu on sales.product_id = menu.product_id
    inner join members on sales.customer_id = members.customer_id
    where sales.order_date < members.join_date
) t
where rn = 1; 

-- What is the total items and amount spent for each member before they became a member?

SELECT
s.customer_id,
COUNT(e.product_id) as items,
SUM(e.price) as gastado
FROM sales s
JOIN menu e 
ON (s.product_id = e.product_id)
JOIN members b
ON (s.customer_id = b.customer_id) 
WHERE s.order_date < b.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

select customer_id, sum(points) as total_points
from (
    select sales.customer_id, menu.product_name, menu.price, 
    case when menu.product_name = 'sushi' then menu.price * 20 else menu.price * 10 end as points
    from sales
    inner join menu on sales.product_id = menu.product_id
) t
group by customer_id

-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not
-- just sushi - how many points do customer A and B have at the end of January?

SELECT customer_id, SUM(points) AS total_points
FROM (
    SELECT sales.customer_id, menu.product_name, menu.price, members.join_date, 
    menu.price * 20 AS points
    FROM sales
    INNER JOIN menu ON sales.product_id = menu.product_id
    INNER JOIN members ON sales.customer_id = members.customer_id
    WHERE sales.order_date >= members.join_date
    AND sales.order_date <= DATEADD(WEEK, 1, members.join_date)
) t
GROUP BY customer_id;
