CREATE DATABASE sql_tasks
USE sql_tasks

SELECT * FROM members


/*1. What is the total amount each customer spent at the restaurant?*/
SELECT sales.customer_id, SUM(menu.price) AS total_spent
FROM sales
INNER JOIN menu ON sales.product_id = menu.product_id
GROUP BY customer_id
ORDER BY customer_id

/* 2. How many days has each customer visited the restaurant?*/
SELECT customer_id, COUNT(DISTINCT order_date) AS days_visited
FROM sales
GROUP BY 1
ORDER BY 1

/*3. What was the first item from the menu purchased by each customer?*/

SELECT sales.customer_id, MIN(sales.order_date) AS first_order, menu.product_name
FROM sales
JOIN menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1, 2 ASC


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT menu.product_name, COUNT(sales.product_id) AS total_purchase
FROM sales
JOIN menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 2 DESC


-- 5. Which item was the most popular for each customer?
SELECT sales.customer_id, COUNT(sales.product_id) AS times_purchased, menu.product_name
FROM sales
JOIN menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1, 2 DESC


-- 6. Which item was purchased first by the customer after they became a member?
SELECT CASE sales.customer_id, MIN(DISTINCT sales.order_date) AS first_order, menu.product_name
FROM sales
JOIN menu
ON sales.product_id = menu.product_id
GROUP BY 1,3
ORDER BY 2 , 1 ASC



-- 7. Which item was purchased just before the customer became a member?
SELECT mb.customer_id, mb.join_date, s.order_date, m.product_name
FROM members mb
JOIN sales s
ON mb.customer_id = s.customer_id
JOIN menu m
ON s.product_id = m.product_id
WHERE mb.customer_id IN ('A', 'B', 'C')
GROUP BY 1,2,3,4
HAVING min(s.order_date) < mb.join_date
ORDER BY 1

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT mb.customer_id, mb.join_date, s.order_date, COUNT(s.product_id) AS amount_bought, m.product_name, SUM(m.price) AS total_spent
FROM members mb
JOIN sales s
ON mb.customer_id = s.customer_id
JOIN menu m
ON s.product_id = m.product_id
GROUP BY 1, 3
HAVING MIN(s.order_date) < mb.join_date
ORDER BY 1

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT s.customer_id, 
SUM(CASE WHEN (m.product_name = 'sushi') THEN (m.price*20)
ELSE (m.price *10) END) AS total_points
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
GROUP BY 1
ORDER BY 1


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT mb.customer_id,
SUM(CASE WHEN(mb.join_date <= s.order_date AND s.order_date <= DATE_ADD(mb.join_date, INTERVAL 7 DAY))
THEN (m.price*20)
ELSE (m.price*10)
END) AS total_points
FROM members mb
JOIN sales s
ON mb.customer_id = s.customer_id
JOIN menu m
ON s.product_id = m.product_id
WHERE mb.customer_id IN ('A', 'B') AND s.order_date BETWEEN '2021-01-01' AND '2021-01-31'
GROUP BY 1
ORDER BY 1


