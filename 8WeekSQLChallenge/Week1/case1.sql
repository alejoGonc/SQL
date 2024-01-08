-- What is the total amount each customer spent at the restaurant?

select sales.customer_id, sum(menu.price) as total_spent
from sales 
inner join menu on sales.product_id = menu.product_id
group by customer_id;

-- How many days has each customer visited the restaurant?

select sales.customer_id, COUNT(DISTINCT sales.order_date) as days_visited
from sales
group by customer_id


-- What was the first item from the menu purchased by each customer?

