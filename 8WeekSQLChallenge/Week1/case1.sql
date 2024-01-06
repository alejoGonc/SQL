-- What is the total amount each customer spent at the restaurant?

select sales.customer_id, sum(menu.price) as total_spent
from sales 
inner join menu on sales.product_id = menu.product_id
group by customer_id;

