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