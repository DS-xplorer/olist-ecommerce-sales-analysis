/*
===========================================================
ADVANCED SQL ANALYSIS
SECTION 1 : CTE
===========================================================
BUSINESS QUESTION:
Which customers generated the highest revenue?
===========================================================
*/

WITH CustomerRevenue AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS total_revenue
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT TOP 10
    customer_id,
    ROUND(total_revenue,2) AS total_revenue
FROM CustomerRevenue
ORDER BY total_revenue DESC;

/*
===========================================================
BUSINESS QUESTION:
Which product categories generated the highest revenue?
===========================================================
*/

WITH CategoryRevenue AS
(
    SELECT
        pr.product_category_name,
        SUM(oi.price) AS total_revenue
    FROM order_items oi
    JOIN products_cleaned pr
        ON oi.product_id = pr.product_id
    GROUP BY pr.product_category_name
)

SELECT
    product_category_name,
    ROUND(total_revenue,2) AS total_revenue
FROM CategoryRevenue
ORDER BY total_revenue DESC;

/*
===========================================================
BUSINESS QUESTION:
What is the monthly revenue trend?
===========================================================
*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    order_year,
    order_month,
    ROUND(revenue,2) AS total_revenue
FROM MonthlyRevenue
ORDER BY order_year, order_month;

/*
===========================================================
BUSINESS QUESTION:
What is the average revenue generated per customer?
===========================================================
*/

WITH CustomerRevenue AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT
    ROUND(AVG(revenue),2) AS average_customer_revenue
FROM CustomerRevenue;

/*
===========================================================
BUSINESS QUESTION:
Which sellers generate above-average revenue?
===========================================================
*/

with sellersrevenue as
(
select
seller_id,
round(sum(price),2) as total_revenue
from order_items
group by seller_id
),

 sellersavg as
(
select 
seller_id,
avg(total_revenue) over() as avg_revenue
from sellersrevenue)

select
sr.seller_id,
sr.total_revenue
from sellersrevenue as sr
join sellersavg as sv
on sr.seller_id=sv.seller_id
where total_revenue>avg_revenue


/*
===========================================================
ADVANCED SQL ANALYSIS
SECTION 2 : ROW_NUMBER()
===========================================================
BUSINESS QUESTION:
Assign a unique row number to sellers based on
their total revenue.
===========================================================
*/

WITH SellerRevenue AS
(
    SELECT
        seller_id,
        SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
)

SELECT
    seller_id,
    ROUND(total_revenue,2) AS total_revenue,
    ROW_NUMBER() OVER(ORDER BY total_revenue DESC) AS row_number
FROM SellerRevenue;

/*
===========================================================
ADVANCED SQL ANALYSIS
SECTION 2 : RANK()
===========================================================
BUSINESS QUESTION:
Rank sellers according to total revenue.
===========================================================
*/

WITH SellerRevenue AS
(
    SELECT
        seller_id,
        SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
)

SELECT
    seller_id,
    ROUND(total_revenue,2) AS total_revenue,
    RANK() OVER(ORDER BY total_revenue DESC) AS seller_rank
FROM SellerRevenue;

/*
===========================================================
ADVANCED SQL ANALYSIS
SECTION 2 : DENSE_RANK()
===========================================================
BUSINESS QUESTION:
Assign dense ranks to sellers based on revenue.
===========================================================
*/

WITH SellerRevenue AS
(
    SELECT
        seller_id,
        SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
)

SELECT
    seller_id,
    ROUND(total_revenue,2) AS total_revenue,
    DENSE_RANK() OVER(ORDER BY total_revenue DESC) AS seller_rank
FROM SellerRevenue;

/*
===========================================================
BUSINESS QUESTION:
Retrieve the top 10 sellers using ROW_NUMBER().
===========================================================
*/

WITH SellerRevenue AS
(
    SELECT
        seller_id,
        SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
),

RankedSeller AS
(
    SELECT
        seller_id,
        total_revenue,
        ROW_NUMBER() OVER(ORDER BY total_revenue DESC) AS row_num
    FROM SellerRevenue
)

SELECT
    seller_id,
    ROUND(total_revenue,2) AS total_revenue
FROM RankedSeller
WHERE row_num <= 10;

/*
===========================================================
BUSINESS QUESTION:
Rank customers based on total spending.
===========================================================
*/

WITH CustomerRevenue AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS total_spent
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT TOP 10
    customer_id,
    ROUND(total_spent,2) AS total_spent,
    RANK() OVER(ORDER BY total_spent DESC) AS customer_rank
FROM CustomerRevenue;

/*
===========================================================
BUSINESS QUESTION:
Rank product categories according to revenue generated.
===========================================================
*/

WITH CategoryRevenue AS
(
    SELECT
        p.product_category_name,
        SUM(oi.price) AS total_revenue
    FROM order_items oi
    JOIN products_cleaned p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)

SELECT
    product_category_name,
    ROUND(total_revenue,2) AS total_revenue,
    DENSE_RANK() OVER(ORDER BY total_revenue DESC) AS category_rank
FROM CategoryRevenue;

/*
===========================================================
ADVANCED SQL ANALYSIS
SECTION 3 : MONTHLY REVENUE
===========================================================
BUSINESS QUESTION:
Calculate monthly revenue from completed orders.
===========================================================
*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(p.payment_value) AS total_revenue
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    order_year,
    order_month,
    ROUND(total_revenue,2) AS total_revenue
FROM MonthlyRevenue
ORDER BY order_year, order_month;

/*
===========================================================
BUSINESS QUESTION:
Calculate cumulative monthly revenue.
===========================================================
*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(p.payment_value) AS total_revenue
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    order_year,
    order_month,
    ROUND(total_revenue,2) AS monthly_revenue,

    ROUND(
        SUM(total_revenue) OVER(
            ORDER BY order_year, order_month
        ),2
    ) AS running_total
FROM MonthlyRevenue;

/*
===========================================================
BUSINESS QUESTION:
Compare monthly revenue with the previous month.
===========================================================
*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(p.payment_value) AS total_revenue
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    order_year,
    order_month,
    ROUND(total_revenue,2) AS current_month,
    ROUND(
        LAG(total_revenue)
        OVER(
            ORDER BY order_year, order_month
        ),2
    ) AS previous_month
FROM MonthlyRevenue;

/*
===========================================================
BUSINESS QUESTION:
Calculate monthly revenue growth.
===========================================================
*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(p.payment_value) AS total_revenue
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    order_year,
    order_month,

    ROUND(total_revenue,2) AS current_month,

    ROUND(
        LAG(total_revenue)
        OVER(
            ORDER BY order_year, order_month
        ),2
    ) AS previous_month,

    ROUND(
        total_revenue -
        LAG(total_revenue)
        OVER(
            ORDER BY order_year, order_month
        ),2
    ) AS revenue_growth
FROM MonthlyRevenue;

/*
===========================================================
BUSINESS QUESTION:
Compare monthly revenue with the next month.
===========================================================
*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(p.payment_value) AS total_revenue
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    order_year,
    order_month,

    ROUND(total_revenue,2) AS current_month,

    ROUND(
        LEAD(total_revenue)
        OVER(
            ORDER BY order_year, order_month
        ),2
    ) AS next_month
FROM MonthlyRevenue;

/*
===========================================================
BUSINESS QUESTION:
Calculate month-over-month revenue growth percentage.
===========================================================
*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(p.payment_value) AS total_revenue
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    order_year,
    order_month,

    ROUND(total_revenue,2) AS current_month,

    ROUND(
        LAG(total_revenue)
        OVER(
            ORDER BY order_year, order_month
        ),2
    ) AS previous_month,

    ROUND(
        total_revenue -
        LAG(total_revenue)
        OVER(
            ORDER BY order_year, order_month
        ),2
    ) AS revenue_growth,
    ROUND(
        (
            (total_revenue -
             LAG(total_revenue)
             OVER(ORDER BY order_year, order_month))
            *100.0
        )
        /
        NULLIF(
            LAG(total_revenue)
            OVER(ORDER BY order_year, order_month),
            0
        ),
        2
    ) AS growth_percentage
FROM MonthlyRevenue;

/*
===========================================================
ADVANCED SQL ANALYSIS
SECTION 4 : CUSTOMER LIFETIME VALUE (CLV)
===========================================================
BUSINESS QUESTION:
Which customers generated the highest lifetime revenue?
===========================================================
*/

WITH CustomerRevenue AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS lifetime_value
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT TOP 10
    customer_id,
    ROUND(lifetime_value,2) AS customer_lifetime_value
FROM CustomerRevenue
ORDER BY lifetime_value DESC;

/*
===========================================================
BUSINESS QUESTION:
How many orders has each customer placed?
===========================================================
*/

SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;

/*
===========================================================
BUSINESS QUESTION:
What is the average spending per customer?
===========================================================
*/

WITH CustomerSpending AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS total_spent
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT
    ROUND(AVG(total_spent),2) AS average_customer_spending
FROM CustomerSpending;

/*
===========================================================
BUSINESS QUESTION:
Which customers placed the highest number of orders?
===========================================================
*/

SELECT TOP 10
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;

/*
===========================================================
BUSINESS QUESTION:
Segment customers based on lifetime spending.
===========================================================
*/

WITH CustomerRevenue AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS total_spent
    FROM orders o
    JOIN payments_cleaned p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(total_spent,2) AS total_spent,

    CASE
        WHEN total_spent >= 1000 THEN 'High Value'
        WHEN total_spent >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment

FROM CustomerRevenue
ORDER BY total_spent DESC;

/*
===========================================================
BUSINESS QUESTION:
Which customers have the highest average order value?
===========================================================
*/

SELECT TOP 10
    o.customer_id,
    ROUND(AVG(p.payment_value),2) AS average_order_value
FROM orders o
JOIN payments_cleaned p
ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY average_order_value DESC;

/*
===========================================================
BUSINESS QUESTION:
What percentage of total revenue is contributed
by each customer?
===========================================================
*/

WITH CustomerRevenue AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments_cleaned p
    ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(revenue,2) AS revenue,

    ROUND(
        revenue * 100.0 /
        SUM(revenue) OVER(),
        2
    ) AS revenue_percentage

FROM CustomerRevenue
ORDER BY revenue DESC;

/*
===========================================================
BUSINESS QUESTION:
Rank customers based on lifetime revenue.
===========================================================
*/

WITH CustomerRevenue AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments_cleaned p
    ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(revenue,2) AS revenue,

    DENSE_RANK() OVER
    (
        ORDER BY revenue DESC
    ) AS customer_rank

FROM CustomerRevenue;

/*
===========================================================
ADVANCED SQL ANALYSIS
SECTION 5 : RFM ANALYSIS
===========================================================
BUSINESS QUESTION:
Analyze customer behavior using Recency, Frequency,
and Monetary (RFM) metrics.
===========================================================
*/

WITH RFM AS
(
    SELECT
        o.customer_id,

        MAX(order_purchase_timestamp) AS last_purchase_date,

        DATEDIFF(
            DAY,
            MAX(order_purchase_timestamp),
            (SELECT MAX(order_purchase_timestamp) FROM orders)
        ) AS recency,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(SUM(p.payment_value),2) AS monetary

    FROM orders o

    JOIN payments_cleaned p
        ON o.order_id = p.order_id

    GROUP BY o.customer_id
)

SELECT *
FROM RFM
ORDER BY monetary DESC;

/*
===========================================================
BUSINESS QUESTION:
Segment customers based on their spending behavior.
===========================================================
*/

WITH CustomerRFM AS
(
    SELECT
        o.customer_id,

        COUNT(DISTINCT o.order_id) AS frequency,

        SUM(p.payment_value) AS monetary

    FROM orders o

    JOIN payments_cleaned p
        ON o.order_id = p.order_id

    GROUP BY o.customer_id
)

SELECT

    customer_id,

    frequency,

    ROUND(monetary,2) AS monetary,

    CASE

        WHEN monetary >= 1000
             AND frequency >= 5
            THEN 'Premium Customer'

        WHEN monetary >= 500
            THEN 'Loyal Customer'

        ELSE 'Regular Customer'

    END AS customer_segment

FROM CustomerRFM

ORDER BY monetary DESC;

/*
===========================================================
BUSINESS QUESTION:
Identify the top 20% of customers based on revenue.
===========================================================
*/

WITH CustomerRevenue AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS revenue

    FROM orders o

    JOIN payments_cleaned p
        ON o.order_id = p.order_id

    GROUP BY o.customer_id
)

SELECT

    customer_id,

    ROUND(revenue,2) AS revenue,

    NTILE(5) OVER
    (
        ORDER BY revenue DESC
    ) AS customer_group

FROM CustomerRevenue;

/*
===========================================================
BUSINESS QUESTION:
Identify the top 20% of sellers based on revenue.
===========================================================
*/

WITH SellerRevenue AS
(
    SELECT

        seller_id,

        SUM(price) AS revenue

    FROM order_items

    GROUP BY seller_id
)

SELECT

    seller_id,

    ROUND(revenue,2) AS revenue,

    NTILE(5) OVER
    (
        ORDER BY revenue DESC
    ) AS seller_group

FROM SellerRevenue;

/*
===========================================================
BUSINESS QUESTION:
Determine each product category's contribution
to total revenue.
===========================================================
*/

WITH CategoryRevenue AS
(
    SELECT

        p.product_category_name,

        SUM(oi.price) AS revenue

    FROM order_items oi

    JOIN products_cleaned p
        ON oi.product_id = p.product_id

    GROUP BY p.product_category_name
)

SELECT

    product_category_name,

    ROUND(revenue,2) AS revenue,

    ROUND
    (
        revenue * 100.0 /
        SUM(revenue) OVER(),
        2
    ) AS revenue_percentage

FROM CategoryRevenue

ORDER BY revenue DESC;
