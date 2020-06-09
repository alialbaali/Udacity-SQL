-- JOIN Questions Part 1
--1
SELECT accounts.name a, sales_reps.name s, region.name r
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
ORDER BY accounts.name

--2
SELECT accounts.name a, (total_amt_usd/(total+0.01)) unit_price, region.name n
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id

/* LAST CHECK */
--1
SELECT a.name account, s.name sales_rep, r.name region
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name LIKE 'Midwest'
ORDER BY a.name

--2
SELECT a.name account, s.name sales_rep, r.name region
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name LIKE 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name

--3
SELECT a.name account, s.name sales_rep, r.name region
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name LIKE 'Midwest' AND s.name LIKE '%K%'
AND s.name NOT LIKE 'K%'
ORDER BY a.name

--4
SELECT a.name account,(o.total_amt_usd/(total+0.01)) unit_price, r.name region
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100


-- 5
SELECT a.name account, (total_amt_usd/(total+0.01)) unit_price, r.name region
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price

--6
SELECT a.name account, (total_amt_usd/(total+0.01)) unit_price, r.name region
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price DESC

--7
SELECT DISTINCT a.name account, w.channel channel, a.id id -- DISTINCT used to narrow the result by removing simillar results(in this case simillar channel names!)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = 1001

--8
SELECT o.occurred_at zaman, a.name account, o.total total, o.total_amt_usd total_amount_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY o.occurred_at 