
/*
===========================================================
               SECTION 7 : REVIEW ANALYSIS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS QUESTION:
-- How are customer review scores distributed?
----------------------------------------------------------

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews_cleaned
GROUP BY review_score
ORDER BY review_score;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What is the average customer review score?
----------------------------------------------------------

SELECT
    avg(review_score) AS average_review_score
FROM reviews_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What percentage of reviews belong to each rating?
----------------------------------------------------------

SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*)*100.0/
        (SELECT COUNT(*) FROM reviews_cleaned),
        2
    ) AS percentage
FROM reviews_cleaned
GROUP BY review_score
ORDER BY review_score;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Which orders received a 5-star rating?
----------------------------------------------------------

SELECT
    order_id,
    review_score
FROM reviews_cleaned
WHERE review_score = 5;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Which orders received a 1-star rating?
----------------------------------------------------------

SELECT
    order_id,
    review_score
FROM reviews_cleaned
WHERE review_score = 1;


----------------------------------------------------------
-- BUSINESS QUESTION:
-- How does the average review score vary by order status?
----------------------------------------------------------

SELECT
    o.order_status,
    avg(r.review_score)  AS average_rating
FROM reviews_cleaned r
JOIN orders o
ON r.order_id = o.order_id
GROUP BY o.order_status
ORDER BY average_rating DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- How many reviews contain customer comments?

----------------------------------------------------------
select
comment_status,
count(*) as total_comeents
from
(
SELECT
CASE
    WHEN review_comment_message = 'No Comment'
        THEN 'No Comment'
    ELSE 'Comment Available'
END AS comment_status

FROM reviews_cleaned
) as comments
group by comment_status

----------------------------------------------------------
-- BUSINESS QUESTION:
-- How many reviews contain review titles?
----------------------------------------------------------

SELECT
CASE
    WHEN review_comment_title = 'No Title'
        THEN 'No Title'
    ELSE 'Title Available'
END AS title_status,

COUNT(*) AS total_reviews

FROM reviews_cleaned

GROUP BY
CASE
    WHEN review_comment_title = 'No Title'
        THEN 'No Title'
    ELSE 'Title Available'
END;


----------------------------------------------------------
-- BUSINESS QUESTION:
-- What is the average number of days taken to respond
-- to customer reviews?
----------------------------------------------------------

SELECT
    ROUND(
        AVG(DATEDIFF(
            DAY,
            review_creation_date,
            review_answer_timestamp
        )),
        2
    ) AS average_response_days
FROM reviews_cleaned;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Summarize customer review performance.
----------------------------------------------------------

SELECT
    COUNT(*) AS total_reviews,
    ROUND(AVG(CAST(review_score AS DECIMAL(5,2))),2) AS average_rating,
    MIN(review_score) AS minimum_rating,
    MAX(review_score) AS maximum_rating
FROM reviews_cleaned;


/*
===========================================================
               SECTION 8 : DELIVERY ANALYSIS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What is the average delivery time in days?
----------------------------------------------------------

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                order_purchase_timestamp,
                order_delivered_customer_date
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Which orders were delivered the fastest?
----------------------------------------------------------

SELECT TOP 10
    order_id,
    DATEDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) AS delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
ORDER BY delivery_days ASC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Which orders took the longest to deliver?
----------------------------------------------------------

SELECT TOP 10
    order_id,
    DATEDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) AS delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
ORDER BY delivery_days DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Which orders were delivered after the estimated date?
----------------------------------------------------------

SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders
WHERE order_delivered_customer_date >
      order_estimated_delivery_date;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- What percentage of orders were delivered on or before
-- the estimated delivery date?
----------------------------------------------------------

SELECT
ROUND(
100.0 *
SUM(CASE
WHEN order_delivered_customer_date <= order_estimated_delivery_date
THEN 1 ELSE 0 END)
/ COUNT(*),
2
) AS on_time_delivery_percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


/*
===========================================================
                GEOGRAPHIC ANALYSIS
===========================================================
*/
----------------------------------------------------------
-- BUSINESS QUESTION:
-- Which states have the largest customer base?
----------------------------------------------------------

SELECT
customer_state,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Which states have the highest number of sellers?
----------------------------------------------------------

SELECT
seller_state,
COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Which customer states generate the highest revenue?
----------------------------------------------------------

SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value),2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments_cleaned p
    ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

----------------------------------------------------------
-- BUSINESS QUESTION:
-- Which seller states generate the highest sales value?
----------------------------------------------------------

SELECT
    s.seller_state,
    ROUND(SUM(oi.price),2) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY total_revenue DESC;










