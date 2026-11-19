create database bank_pr;

use bank_pr;





DESC `bank customer churn prediction`;
SHOW TABLES;


-- =========================================================
-- PROJECT: BANK CUSTOMER CHURN PREDICTION
-- DATABASE: bank_pr
-- PURPOSE: Analyze customer churn, retention, balances,
--          credit scores, customer demographics and activity.
-- =========================================================


-- =========================================================
-- SECTION 1: DATABASE AND TABLE SETUP
-- =========================================================

-- 1. Create the database
CREATE DATABASE IF NOT EXISTS bank_pr;

-- 2. Select the database
USE bank_pr;

-- 3. Display all tables in the database
SHOW TABLES;

-- 4. Display the structure of the customer churn table
DESC `bank customer churn prediction`;

-- 5. Display the first 10 customer records
SELECT *
FROM `bank customer churn prediction`
LIMIT 10;


-- =========================================================
-- SECTION 2: BASIC CUSTOMER INFORMATION
-- =========================================================

-- 6. Find the total number of customer records
SELECT COUNT(*) AS total_customers
FROM `bank customer churn prediction`;

-- 7. Find the total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM `bank customer churn prediction`;

-- 8. Check for missing values in all important columns
SELECT
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(credit_score IS NULL) AS missing_credit_score,
    SUM(country IS NULL) AS missing_country,
    SUM(gender IS NULL) AS missing_gender,
    SUM(age IS NULL) AS missing_age,
    SUM(tenure IS NULL) AS missing_tenure,
    SUM(balance IS NULL) AS missing_balance,
    SUM(products_number IS NULL) AS missing_products,
    SUM(credit_card IS NULL) AS missing_credit_card,
    SUM(active_member IS NULL) AS missing_active_member,
    SUM(estimated_salary IS NULL) AS missing_salary,
    SUM(churn IS NULL) AS missing_churn
FROM `bank customer churn prediction`;


-- =========================================================
-- SECTION 3: CUSTOMER CHURN AND RETENTION ANALYSIS
-- =========================================================

-- 9. Display the distribution of churned and retained customers
-- churn = 1 means the customer left
-- churn = 0 means the customer stayed
SELECT
    churn,
    COUNT(*) AS total_customers
FROM `bank customer churn prediction`
GROUP BY churn
ORDER BY churn;

-- 10. Calculate the overall customer churn rate
SELECT
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`;

-- 11. Calculate the customer retention rate
SELECT
    ROUND(AVG(churn = 0) * 100, 2)
        AS retention_rate_percentage
FROM `bank customer churn prediction`;

-- 12. Analyze customer churn by country
SELECT
    country,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY country
ORDER BY churn_rate_percentage DESC;

-- 13. Analyze customer churn by gender
SELECT
    gender,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY gender
ORDER BY churn_rate_percentage DESC;

-- 14. Analyze churn based on active membership
-- active_member = 1 means active
-- active_member = 0 means inactive
SELECT
    active_member,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY active_member
ORDER BY active_member DESC;

-- 15. Analyze churn based on credit card ownership
SELECT
    credit_card,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY credit_card;

-- 16. Analyze churn based on the number of bank products
SELECT
    products_number,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY products_number
ORDER BY products_number;

-- 17. Analyze churn based on customer tenure
SELECT
    tenure,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY tenure
ORDER BY tenure;

-- 18. Find countries with a churn rate above 20%
SELECT
    country,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY country
HAVING AVG(churn) > 0.20
ORDER BY churn_rate_percentage DESC;


-- =========================================================
-- SECTION 4: ACCOUNT BALANCE AND SALARY ANALYSIS
-- =========================================================

-- 19. Calculate the total account balance of all customers
SELECT
    ROUND(SUM(balance), 2) AS total_account_balance
FROM `bank customer churn prediction`;

-- 20. Calculate the average account balance
SELECT
    ROUND(AVG(balance), 2) AS average_account_balance
FROM `bank customer churn prediction`;

-- 21. Find the 10 customers with the highest account balances
SELECT
    customer_id,
    country,
    balance
FROM `bank customer churn prediction`
ORDER BY balance DESC
LIMIT 10;

-- 22. Find the 10 customers with the lowest account balances
SELECT
    customer_id,
    country,
    balance
FROM `bank customer churn prediction`
ORDER BY balance ASC
LIMIT 10;

-- 23. Calculate the average estimated salary by country
SELECT
    country,
    ROUND(AVG(estimated_salary), 2) AS average_salary
FROM `bank customer churn prediction`
GROUP BY country
ORDER BY average_salary DESC;

-- 24. Find customers whose balance is above the overall average
SELECT
    customer_id,
    country,
    balance
FROM `bank customer churn prediction`
WHERE balance > (
    SELECT AVG(balance)
    FROM `bank customer churn prediction`
)
ORDER BY balance DESC;

-- 25. Analyze churn by account balance group
SELECT
    CASE
        WHEN balance = 0 THEN 'Zero Balance'
        WHEN balance < 50000 THEN 'Low Balance'
        WHEN balance < 100000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END AS balance_group,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY balance_group
ORDER BY churn_rate_percentage DESC;


-- =========================================================
-- SECTION 5: CUSTOMER AGE ANALYSIS
-- =========================================================

-- 26. Calculate average age for churned and retained customers
SELECT
    churn,
    COUNT(*) AS total_customers,
    ROUND(AVG(age), 2) AS average_age
FROM `bank customer churn prediction`
GROUP BY churn
ORDER BY churn;

-- 27. Analyze customer churn by age group
SELECT
    CASE
        WHEN age < 30 THEN 'Below 30'
        WHEN age < 40 THEN '30-39'
        WHEN age < 50 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY age_group
ORDER BY churn_rate_percentage DESC;


-- =========================================================
-- SECTION 6: CREDIT SCORE ANALYSIS
-- =========================================================

-- 28. Find customers with credit scores below 600
SELECT
    customer_id,
    credit_score,
    country,
    age,
    churn
FROM `bank customer churn prediction`
WHERE credit_score < 600
ORDER BY credit_score ASC;

-- 29. Calculate the average credit score by country
SELECT
    country,
    ROUND(AVG(credit_score), 2) AS average_credit_score
FROM `bank customer churn prediction`
GROUP BY country
ORDER BY average_credit_score DESC;

-- 30. Analyze churn by credit score group
SELECT
    CASE
        WHEN credit_score < 580 THEN 'Low'
        WHEN credit_score < 670 THEN 'Fair'
        WHEN credit_score < 740 THEN 'Good'
        ELSE 'Very Good or Excellent'
    END AS credit_score_group,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY credit_score_group
ORDER BY churn_rate_percentage DESC;


-- =========================================================
-- SECTION 7: CUSTOMER RANKING AND RETENTION REVIEW
-- =========================================================

-- 31. Display the top 10 customers by account balance
SELECT
    customer_id,
    country,
    balance,
    churn
FROM `bank customer churn prediction`
ORDER BY balance DESC
LIMIT 10;

-- 32. Rank all customers according to account balance
-- Requires MySQL 8.0 or later
SELECT
    customer_id,
    country,
    balance,
    RANK() OVER (
        ORDER BY balance DESC
    ) AS balance_rank
FROM `bank customer churn prediction`;

-- 33. Rank countries according to their churn rate
-- Requires MySQL 8.0 or later
SELECT
    country,
    total_customers,
    customers_lost,
    churn_rate_percentage,
    RANK() OVER (
        ORDER BY churn_rate_percentage DESC
    ) AS churn_rank
FROM (
    SELECT
        country,
        COUNT(*) AS total_customers,
        SUM(churn) AS customers_lost,
        ROUND(AVG(churn) * 100, 2)
            AS churn_rate_percentage
    FROM `bank customer churn prediction`
    GROUP BY country
) AS country_summary;

-- 34. Identify potentially at-risk customers for review
-- Criteria: inactive, fewer than 2 products, and above-average balance
SELECT
    customer_id,
    country,
    age,
    balance,
    products_number,
    active_member,
    churn
FROM `bank customer churn prediction`
WHERE active_member = 0
  AND products_number < 2
  AND balance > (
      SELECT AVG(balance)
      FROM `bank customer churn prediction`
  )
ORDER BY balance DESC;


-- =========================================================
-- SECTION 8: BANK PERFORMANCE SUMMARY
-- =========================================================

-- 35. Generate an overall bank customer performance report
SELECT
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    SUM(churn = 0) AS customers_retained,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(credit_score), 2) AS average_credit_score,
    ROUND(AVG(age), 2) AS average_age
FROM `bank customer churn prediction`;

-- 36. Compare performance of active and inactive customers
SELECT
    active_member,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    SUM(churn = 0) AS customers_retained,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage,
    ROUND(AVG(balance), 2) AS average_balance
FROM `bank customer churn prediction`
GROUP BY active_member
ORDER BY active_member DESC;


-- =========================================================
-- SECTION 9: ADVANCED CUSTOMER ANALYSIS
-- =========================================================

-- 37. Analyze churn by age group and gender
SELECT
    CASE
        WHEN age < 30 THEN 'Below 30'
        WHEN age < 40 THEN '30-39'
        WHEN age < 50 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,
    gender,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY age_group, gender
ORDER BY age_group, churn_rate_percentage DESC;

-- 38. Display customer distribution by country and gender
SELECT
    country,
    gender,
    COUNT(*) AS total_customers
FROM `bank customer churn prediction`
GROUP BY country, gender
ORDER BY country, total_customers DESC;

-- 39. Analyze churn by number of products and active membership
SELECT
    products_number,
    active_member,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY products_number, active_member
ORDER BY products_number, active_member;

-- 40. Analyze churn by credit card ownership and active membership
SELECT
    credit_card,
    active_member,
    COUNT(*) AS total_customers,
    SUM(churn) AS customers_lost,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `bank customer churn prediction`
GROUP BY credit_card, active_member
ORDER BY churn_rate_percentage DESC;


-- =========================================================
-- SECTION 10: COMPLETE CUSTOMER DETAIL REPORT
-- =========================================================

-- 41. Display all customer details, showing churned customers first
-- Within each churn status, sort customers by age in descending order
SELECT
    customer_id,
    country,
    gender,
    age,
    credit_score,
    tenure,
    balance,
    products_number,
    credit_card,
    active_member,
    estimated_salary,
    churn
FROM `bank customer churn prediction`
ORDER BY churn DESC, age DESC;


-- =========================================================
-- END OF BANK CUSTOMER CHURN PREDICTION SQL PROJECT
-- =========================================================
SELECT USER();