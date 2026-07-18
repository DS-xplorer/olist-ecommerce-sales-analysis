/*
===========================================================
STAR SCHEMA
FACT TABLE : FACT_SALES
===========================================================
Business Purpose:
Create a central fact table containing all sales
transactions for business analysis.
===========================================================
*/

SELECT

    oi.order_id,

    o.customer_id,

    oi.product_id,

    oi.seller_id,

    CAST(o.order_purchase_timestamp AS DATE) AS Order_Date,

    p.payment_type,

    p.payment_installments,

    oi.price,

    oi.freight_value,

    p.payment_value,

    r.review_score

INTO Fact_Sales

FROM order_items oi

INNER JOIN orders o
ON oi.order_id = o.order_id

INNER JOIN payments_cleaned p
ON oi.order_id = p.order_id

LEFT JOIN reviews_cleaned r
ON oi.order_id = r.order_id;

/*
===========================================================
DIMENSION TABLE : DIM_CUSTOMERS
===========================================================
*/

SELECT

customer_id,
customer_unique_id,
customer_city,
customer_state

INTO Dim_Customers

FROM customers;

/*
===========================================================
DIMENSION TABLE : DIM_PRODUCTS
===========================================================
*/

SELECT

product_id,
product_category_name,
product_name_lenght,
product_description_lenght,
product_photos_qty,
product_weight_g,
product_length_cm,
product_height_cm,
product_width_cm

INTO Dim_Products

FROM products_cleaned;

/*
===========================================================
DIMENSION TABLE : DIM_SELLERS
===========================================================
*/

SELECT

seller_id,
seller_city,
seller_state

INTO Dim_Sellers

FROM sellers;

/*
===========================================================
DIMENSION TABLE : DIM_PAYMENTS
===========================================================
*/

SELECT

order_id,
payment_type,
payment_installments,
payment_value

INTO Dim_Payments

FROM payments_cleaned;

/*
===========================================================
DIMENSION TABLE : DIM_CATEGORY
===========================================================
*/

SELECT

product_category_name,
product_category_name_english

INTO Dim_Category

FROM category_translation;

/*
===========================================================
DIMENSION TABLE : DIM_DATE
===========================================================
*/

SELECT DISTINCT

CAST(order_purchase_timestamp AS DATE) AS Order_Date,

YEAR(order_purchase_timestamp) AS Year,

MONTH(order_purchase_timestamp) AS Month,

DATENAME(MONTH,order_purchase_timestamp) AS Month_Name,

DATEPART(QUARTER,order_purchase_timestamp) AS Quarter,

DAY(order_purchase_timestamp) AS Day,

DATENAME(WEEKDAY,order_purchase_timestamp) AS Day_Name

INTO Dim_Date

FROM orders;


