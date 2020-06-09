-- LEFT & RIGHT --

-- 1
SELECT RIGHT(website, 3) AS extension, COUNT(*) num
FROM accounts
GROUP BY 1

-- 2
SELECT LEFT(name, 1) f_let, COUNT (*) AS num
FROM accounts
GROUP BY 1
ORDER BY 2 DESC

-- 3
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num,
        CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
    FROM accounts) t1;

-- 4
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                        THEN 1 ELSE 0 END AS vowels,
        CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                       THEN 0 ELSE 1 END AS other
    FROM accounts) t1;


-- POSITION, STRPOS, UPPER, LOWER --

-- 1
SELECT primary_poc,
    LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
    RIGHT(primary_poc,LENGTH(primary_poc) - LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc)))) AS last_name
FROM accounts

-- 2
SELECT name,
    LEFT(name, POSITION(' ' IN name)-1) AS first_name,
    RIGHT(name,LENGTH(name) - LENGTH(LEFT(name, POSITION(' ' IN name)))) AS last_name
FROM sales_reps

-- CONCAT , || --

-- 1
SELECT primary_poc, CONCAT(LEFT(primary_poc, POSITION(' ' IN primary_poc)-1), '.', RIGHT(primary_poc,LENGTH(primary_poc) - LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc)))), '@', name, '.com') AS email_address
FROM accounts

-- 2
WITH t1
AS
(SELECT CONCAT(LEFT(primary_poc, POSITION(' ' IN primary_poc)- 1), '.', RIGHT(primary_poc,LENGTH(primary_poc) - LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc)))), '@', name, '.com') AS email_address
FROM accounts)

SELECT CASE WHEN POSITION(' ' IN email_address) = 0 THEN email_address ELSE CONCAT(LEFT(email_address,POSITION(' ' IN email_address) - 1),
RIGHT(email_address,LENGTH(email_address) - LENGTH(LEFT(email_address, POSITION(' ' IN email_address))))) END AS result
FROM t1

-- OR -- 
WITH t1
AS
(
SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM t1;

-- 3
WITH
    t1
    AS
    (
        SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
        FROM accounts
    )
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;