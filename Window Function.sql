-- Window Function --

-- 1
SELECT standard_amt_usd, SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders

-- 2
SELECT standard_amt_usd,
    DATE_TRUNC('year', occurred_at), SUM(standard_amt_usd) OVER 
(PARTITION BY DATE_TRUNC('year', occurred_at)
 ORDER BY occurred_at) AS running_total
FROM orders