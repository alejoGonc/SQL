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
-- (revisar)

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

-- What is the total items and amount spent for each member before they became a member?

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not
-- just sushi - how many points do customer A and B have at the end of January?