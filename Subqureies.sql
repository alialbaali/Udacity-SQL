-- Subquery Mania --

-- 1
SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
    FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
        FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
        GROUP BY 1, 2) t1
    GROUP BY 1) t2
    JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
    FROM sales_reps s
        JOIN accounts a
        ON a.sales_rep_id = s.id
        JOIN orders o
        ON o.account_id = a.id
        JOIN region r
        ON r.id = s.region_id
    GROUP BY 1,2
    ORDER BY 3 DESC) t3
    ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

-- 2
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
    JOIN accounts a
    ON a.sales_rep_id = s.id
    JOIN orders o
    ON o.account_id = a.id
    JOIN region r
    ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
    FROM sales_reps s
        JOIN accounts a
        ON a.sales_rep_id = s.id
        JOIN orders o
        ON o.account_id = a.id
        JOIN region r
        ON r.id = s.region_id
    GROUP BY r.name) sub);

-- 3
SELECT COUNT(*)
FROM (SELECT a.name
    FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
    GROUP BY 1
    HAVING SUM(o.total) > (SELECT total
    FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
        FROM accounts a
            JOIN orders o
            ON o.account_id = a.id
        GROUP BY 1
        ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;

-- 4
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id AND a.id =  (SELECT id
        FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
            FROM orders o
                JOIN accounts a
                ON a.id = o.account_id
            GROUP BY a.id, a.name
            ORDER BY 3 DESC
                           LIMIT 1) inner_table)
        GROUP BY 1, 2
        ORDER BY 3 DESC;

-- 5
SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
    FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
    GROUP BY a.id, a.name
    ORDER BY 3 DESC
       LIMIT 10) temp;

-- 6
SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
    FROM orders o)) temp_table;

-- WITH --

-- 1
WITH
    t1
    AS
    (
        SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
        FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
        GROUP BY 1,2
        ORDER BY 3 DESC
    ),
    t2
    AS
    (
        SELECT region_name, MAX(total_amt) total_amt
        FROM t1
        GROUP BY 1
    )
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
    JOIN t2
    ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;

-- 2
WITH
    t1
    AS
    (
        SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
        FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
        GROUP BY r.name
    ),
    t2
    AS
    (
        SELECT MAX(total_amt)
        FROM t1
    )
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
    JOIN accounts a
    ON a.sales_rep_id = s.id
    JOIN orders o
    ON o.account_id = a.id
    JOIN region r
    ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT *
FROM t2);

-- 3

WITH
    t1
    AS
    (
        SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
        FROM accounts a
            JOIN orders o
            ON o.account_id = a.id
        GROUP BY 1
        ORDER BY 2 DESC
  LIMIT 1), 
t2
     AS
(
  SELECT a.name
FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (SELECT total
FROM t1))
SELECT COUNT(*)
FROM t2;

-- 4

WITH
    t1
    AS
    (
        SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
        FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
        GROUP BY a.id, a.name
        ORDER BY 3 DESC
   LIMIT 1)
SELECT a
    .name, w.channel, COUNT
(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =
(SELECT id
FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 5
WITH
    t1
    AS
    (
        SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
        FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
        GROUP BY a.id, a.name
        ORDER BY 3 DESC
   LIMIT 10)
SELECT AVG
    (tot_spent)
FROM t1;

-- 6
WITH
    t1
    AS
    (
        SELECT AVG(o.total_amt_usd) avg_all
        FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
    ),
    t2
    AS
    (
        SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
        FROM orders o
        GROUP BY 1
        HAVING AVG(o.total_amt_usd) > (SELECT *
        FROM t1)
    )
SELECT AVG(avg_amt)
FROM t2;