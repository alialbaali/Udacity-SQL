
--  GROUP BY PART 1 
--1
SELECT a.name account_name, o.occurred_at order_date
FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
ORDER BY a.name, o.occurred_at

--2
SELECT a.name account_name, SUM(o.total_amt_usd) total_sales
FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name
LIMIT 100

--3
SELECT a
.name account_name, w.occurred_at _date, w.channel channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 10;

--4
SELECT w.channel channel, COUNT(w.occurred_at) _date
FROM web_events w
GROUP BY w.channel

--5
SELECT a.primary_poc primary_contact, w.occurred_at _date
FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1


--6
SELECT a
.name account_name, MIN
(o.total_amt_usd) total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name

--7
SELECT r.name region, COUNT(*) sales_rep
FROM region r
    JOIN sales_reps s
    ON r.id = s.region_id
GROUP BY r.name
ORDER BY COUNT(*)

-- GROUP BY PART 2 --

--1
SELECT a.name, AVG(o.standard_qty) standard_qty, AVG(o.gloss_qty) gloss_qty, AVG(o.poster_qty) poster_qty
FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name

--2
SELECT a.name, AVG(o.standard_amt_usd) standard_avg, AVG(o.gloss_amt_usd) gloss_avg, AVG(o.poster_amt_usd) poster_avg
FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name

--3
SELECT s.name sales_rep_name, w.channel channel, COUNT(*) num_of_times
FROM accounts a
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN web_events w
    ON a.id = w.account_id
GROUP BY s.name, channel
ORDER BY COUNT(*) DESC

--4
SELECT r.name region, w.channel channel, COUNT(*) num_of_times
FROM accounts a
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN web_events w
    ON a.id = w.account_id
    JOIN region r
    ON r.id = s.region_id
GROUP BY region, channel
ORDER BY COUNT(*) DESC

-- DISTINCT --

--1 
SELECT DISTINCT a.name account
FROM accounts a
    JOIN sales_reps s
    ON a.sales_rep_id = s.id
    JOIN region r
    ON s.region_id = r.id

--2 
SELECT DISTINCT s.name
FROM sales_reps s
    JOIN accounts a
    ON s.id = a.sales_rep_id

-- HAVING -- 

--1
SELECT s.name rep_name, COUNT(a.*) num_of_accounts
FROM sales_reps s
    JOIN accounts a
    ON s.id = a.sales_rep_id
GROUP BY 1
HAVING COUNT(a.*) > 5
ORDER BY 2 DESC

--2 
SELECT a.name account, COUNT(o.*) num_of_orders
FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
GROUP BY 1
HAVING COUNT(o.*) > 20
ORDER BY num_of_orders DESC

-- OR 

SELECT DISTINCT a.name account
FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
GROUP BY 1
HAVING COUNT(o.*) > 20

--3
SELECT a.name account, COUNT(o.*) num_of_orders
FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
GROUP BY 1
HAVING COUNT(o.*) > 20
ORDER BY num_of_orders DESC
LIMIT 1;

-- 4
SELECT a
.id, a.name, SUM
(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM
(o.total_amt_usd) > 30000
ORDER BY total_spent;

--5 
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

--6
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

--7
SELECT a
.id, a.name, SUM
(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

--8
SELECT a.name account, w.channel channel, COUNT(w.*) num_of_times
FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id
WHERE channel LIKE 'facebook'
GROUP BY 1,2
HAVING COUNT(w.*) > 6
ORDER BY 3 DESC

--9
SELECT a.name account, w.channel channel, COUNT(w.*) num_of_times
FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id
WHERE channel LIKE 'facebook'
GROUP BY 1,2
HAVING COUNT(w.*) > 6
ORDER BY 3 DESC
LIMIT 1;

-- 10
SELECT w
.channel, COUNT
(a.name) accounts
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
GROUP BY w.channel
ORDER BY 2 DESC
LIMIT 1

-- DATE --

-- 1
SELECT DATE_PART('year', occurred_at) ord_year, SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 2
SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 

-- 3
SELECT DATE_PART('year', occurred_at) AS year_date,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC

--4
SELECT DATE_PART('month', occurred_at) AS year_date, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC

--5
SELECT DATE_TRUNC('month', o.occurred_at) AS date, a.name, SUM(o.gloss_amt_usd)total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1

-- CASE --

-- 1
SELECT account_id, total_amt_usd,
CASE WHEN total_amt_usd > 3000 THEN 'Large'
ELSE 'Small' END AS order_level
FROM orders;

--2 
SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
   WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
   ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

-- 3
SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;

--4
SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' 
GROUP BY 1
ORDER BY 2 DESC;

--5
SELECT s.name, COUNT(*) num_ords,
     CASE WHEN COUNT(*) > 200 THEN 'top'
     ELSE 'not' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC;

-- 6
SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent, 
     CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
     WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
     ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;