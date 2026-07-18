
/*
===========================================================
EXPLORATORY DATA ANALYSIS (EDA)
===========================================================

Project:
Brazilian E-Commerce (Olist)

Objective:
Explore the dataset to understand sales performance,
customer behavior, products, payments, reviews,
and business trends before building dashboards.
===========================================================
*/


----------------------------------------------------------
-- BUSINESS QUESTION:
-- How many customers are in the database?
----------------------------------------------------------

SELECT COUNT(*) AS total_customers
FROM customers;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- How many orders exist?
----------------------------------------------------------

SELECT COUNT(*) AS total_orders
FROM orders;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- How many products are available?
----------------------------------------------------------

SELECT COUNT(*) AS total_products
FROM products_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- How many sellers are registered?
----------------------------------------------------------

SELECT COUNT(*) AS total_sellers
FROM sellers;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- How many customer reviews exist?
----------------------------------------------------------

SELECT COUNT(*) AS total_reviews
FROM reviews_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- How many payment transactions exist?
----------------------------------------------------------

SELECT COUNT(*) AS total_payments
FROM payments_cleaned;


/*
===========================================================
SALES OVERVIEW
===========================================================
*/

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What is the total revenue generated?
----------------------------------------------------------

SELECT
ROUND(SUM(payment_value),2) AS total_revenue
FROM payments_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What is the average payment value?
----------------------------------------------------------

SELECT
ROUND(AVG(payment_value),2) AS average_payment
FROM payments_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What is the highest payment value?
----------------------------------------------------------

SELECT
MAX(payment_value) AS highest_payment
FROM payments_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What is the lowest payment value?
----------------------------------------------------------

SELECT
MIN(payment_value) AS lowest_payment
FROM payments_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What is the total freight cost?
----------------------------------------------------------

SELECT
ROUND(SUM(freight_value),2) AS total_freight
FROM order_items;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What is the average freight cost?
----------------------------------------------------------

SELECT
ROUND(AVG(freight_value),2) AS average_freight
FROM order_items;


/*
===========================================================
ORDER ANALYSIS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS QUESTION:
-- How many orders exist by status?
----------------------------------------------------------

SELECT
order_status,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Orders placed by year.
----------------------------------------------------------

SELECT
YEAR(order_purchase_timestamp) AS order_year,
COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Orders placed by month.
----------------------------------------------------------

SELECT
YEAR(order_purchase_timestamp) AS order_year,
MONTH(order_purchase_timestamp) AS order_month,
COUNT(*) AS total_orders
FROM orders
GROUP BY
YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp)
ORDER BY
order_year,
order_month;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Average delivery days.
----------------------------------------------------------

SELECT
AVG(DATEDIFF(day,
order_purchase_timestamp,
order_delivered_customer_date))
AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/*
===========================================================
CUSTOMER ANALYSIS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Top 10 customer states.
----------------------------------------------------------

SELECT TOP 10
customer_state,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Top 10 customer cities.
----------------------------------------------------------

SELECT TOP 10
customer_city,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Customers by state.
----------------------------------------------------------

SELECT
customer_state,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

/*
===========================================================
PRODUCT ANALYSIS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Top product categories.
----------------------------------------------------------

SELECT TOP 10
product_category_name,
COUNT(*) AS total_products
FROM products_cleaned
GROUP BY product_category_name
ORDER BY total_products DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Average product weight.
----------------------------------------------------------

SELECT
AVG(product_weight_g) AS average_weight
FROM products_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Average product photos.
----------------------------------------------------------

SELECT
AVG(product_photos_qty) AS average_photos
FROM products_cleaned;


/*
===========================================================
SELLER ANALYSIS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Sellers by state.
----------------------------------------------------------

SELECT
seller_state,
COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Top seller cities.
----------------------------------------------------------

SELECT TOP 10
seller_city,
COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_city
ORDER BY total_sellers DESC;

/*
===========================================================
PAYMENT ANALYSIS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Payment type distribution.
----------------------------------------------------------

SELECT
payment_type,
COUNT(*) AS total_transactions
FROM payments_cleaned
GROUP BY payment_type
ORDER BY total_transactions DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Average payment by payment type.
----------------------------------------------------------

SELECT
payment_type,
ROUND(AVG(payment_value),2) AS average_payment
FROM payments_cleaned
GROUP BY payment_type
ORDER BY average_payment DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Average installments by payment type.
----------------------------------------------------------

SELECT
payment_type,
AVG(payment_installments) AS avg_installments
FROM payments_cleaned
GROUP BY payment_type;

/*
===========================================================
REVIEW ANALYSIS
===========================================================
*/
----------------------------------------------------------
-- BUSINESS QUESTION:
-- Average review score.
----------------------------------------------------------

SELECT
AVG(review_score) AS average_rating
FROM reviews_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Review score distribution.
----------------------------------------------------------

SELECT
review_score,
COUNT(*) AS total_reviews
FROM reviews_cleaned
GROUP BY review_score
ORDER BY review_score;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Percentage of 5-star reviews.
----------------------------------------------------------

SELECT
COUNT(*)*100.0/
(SELECT COUNT(*) FROM reviews_cleaned)
AS five_star_percentage
FROM reviews_cleaned
WHERE review_score=5;

/*
===========================================================
GEOGRAPHIC ANALYSIS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Customer distribution by state.
----------------------------------------------------------

SELECT
customer_state,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Seller distribution by state.
----------------------------------------------------------

SELECT
seller_state,
COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;