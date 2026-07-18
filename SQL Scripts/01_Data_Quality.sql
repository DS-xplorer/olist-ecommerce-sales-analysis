/*
===========================================================
PROJECT: E-Commerce Business Performance Analysis
DATASET: Olist Brazilian E-Commerce
PHASE: Data Quality Assessment
AUTHOR: Vibha Rana
===========================================================

Objective:
Before performing any business analysis, validate the quality
of the imported data.

Checks Included:
1. Row Count
2. Missing Values
3. Duplicate Records
4. Invalid Values
5. Business Rule Validation

===========================================================
*/

/* ===========================================================
TABLE 1 : CUSTOMERS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Verify total number of customer records
----------------------------------------------------------

select count(*) as total_customers
from customers;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- View sample customer data
----------------------------------------------------------

select top 10*
from customers;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check for NULL values
----------------------------------------------------------

select 
sum(case when customer_id is null then 1 else 0 end) as customer_id_null,
sum(case when customer_unique_id is null then 1 else 0 end) as customer_unique_id_null,
sum(case when customer_zip_code_prefix is null then 1 else 0 end) as customer_zip_code_prefix_null,
SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS customer_city_nulls,
SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS customer_state_nulls
from customers;


----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check duplicate Customer IDs
----------------------------------------------------------

select 
customer_id,
count(*) as duplicate_value
from customers
group by (customer_id)
having count(*)>1;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check for blank values in text columns
----------------------------------------------------------

select
customer_state
from customers
where customer_state='';

select
customer_city
from customers
where customer_city=''

/*
===========================================================
SUMMARY : CUSTOMERS TABLE
===========================================================

Business Objective:
Validate the quality and completeness of customer data before
using it for business analysis and reporting.

-----------------------------------------------------------
Data Quality Findings
-----------------------------------------------------------

Total Records            : 99,441

Duplicate Customer IDs   : 0
Status                   : PASS

NULL Value Check

customer_id              : 0
customer_unique_id       : 0
customer_zip_code_prefix : 0
customer_city            : 0
customer_state           : 0

Blank Value Check

customer_city            : 0
customer_state           : 0

-----------------------------------------------------------
Business Validation
-----------------------------------------------------------

? Every customer has a unique customer_id.
? No duplicate customer records were found.
? No NULL values exist in any customer column.
? No blank values were found in customer_city or customer_state.
? Customer location information is complete and reliable.

-----------------------------------------------------------
Business Impact
-----------------------------------------------------------

The Customers table is clean and complete. It can be safely
used for customer segmentation, geographic analysis,
state-wise sales analysis, customer behavior analysis,
and dashboard reporting.

-----------------------------------------------------------
Status
-----------------------------------------------------------

✅ DATA QUALITY CHECK PASSED

✅ READY FOR BUSINESS ANALYSIS

===========================================================
*/




/* ===========================================================
TABLE 2 : ORDERS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Verify total number of orders
----------------------------------------------------------

select count(*) as total_orders
from orders;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- View sample customer data
----------------------------------------------------------

select top 10*
from orders;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check NULL values
----------------------------------------------------------

SELECT

SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,

SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,

SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS status_nulls,

SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS purchase_date_nulls,

SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS approved_nulls,

SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS delivered_carrier_nulls,

SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS delivered_date_nulls,

SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS estimated_delivery_nulls

FROM orders;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check duplicate Order IDs
----------------------------------------------------------

SELECT
order_id,
COUNT(*) AS Duplicate_Count
FROM orders
GROUP BY order_id
HAVING COUNT(*)>1;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Validate delivery dates
--
-- A delivered order should never be delivered
-- before it was purchased.
----------------------------------------------------------

SELECT *
FROM orders
WHERE order_delivered_customer_date
<
order_purchase_timestamp;


----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check invalid estimated delivery dates
----------------------------------------------------------

SELECT *
FROM orders
WHERE order_estimated_delivery_date
<
order_purchase_timestamp;

/*
===========================================================
SUMMARY : ORDERS TABLE
===========================================================

Business Objective:
Validate the integrity and completeness of order data before
performing sales, delivery, and customer behavior analysis.

-----------------------------------------------------------
Data Quality Findings
-----------------------------------------------------------

Total Records            : 99,441

Duplicate Order IDs      : 0
Status                   : PASS

NULL Value Check

order_id                         : 0
customer_id                      : 0
order_status                     : 0
order_purchase_timestamp         : 0
order_approved_at                : 160
order_delivered_carrier_date     : 1,783
order_delivered_customer_date    : 2,965
order_estimated_delivery_date    : 0

Blank Value Check

No blank values found in any text column.

-----------------------------------------------------------
Business Rule Validation
-----------------------------------------------------------

? No orders were delivered before the purchase date.
? No estimated delivery dates occur before the purchase date.
? Order timeline is logically consistent.

-----------------------------------------------------------
Business Observation
-----------------------------------------------------------

• The Orders table contains complete information for all
  key identifiers and purchase details.

• NULL values in approval and delivery date columns are
  expected for orders that were cancelled, unavailable,
  or not yet delivered.

• No duplicate Order IDs were found, ensuring each order
  is uniquely identified.

-----------------------------------------------------------
Business Impact
-----------------------------------------------------------

The Orders table is reliable for sales analysis, customer
behavior analysis, delivery performance evaluation,
order lifecycle analysis, and KPI reporting.

The delivery-related NULL values should be considered
during analysis and filtered based on order status where
necessary.

-----------------------------------------------------------
Status
-----------------------------------------------------------

✅ DATA QUALITY CHECK PASSED

✅ READY FOR BUSINESS ANALYSIS

===========================================================
*/




/* ===========================================================
TABLE 3 : ORDER_ITEMS
===========================================================
*/
----------------------------------------------------------
-- BUSINESS PURPOSE:
-- total order items
----------------------------------------------------------
select count(*) as total_order_items 
from order_items; 

---------------------------------------------------------- 
-- BUSINESS PURPOSE: 
-- View order items sample data 
---------------------------------------------------------- 

select top 10* 
from order_items;

---------------------------------------------------------- 
-- BUSINESS PURPOSE: 
-- Check NULL values 
----------------------------------------------------------

select 
SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS item_id_nulls, 
SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls, 
SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS shipping_nulls, 
SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls, 
SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS freight_nulls from order_items;

---------------------------------------------------------- 
-- BUSINESS PURPOSE: 
-- Check negative prices 
---------------------------------------------------------- 

SELECT * 
FROM order_items
WHERE price <0;

---------------------------------------------------------- 
-- BUSINESS PURPOSE: 
-- Check negative freight charges
---------------------------------------------------------- 

SELECT *
FROM order_items 
WHERE freight_value<0; 

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check duplicate Order Items
----------------------------------------------------------

SELECT order_id, 
order_item_id,
COUNT(*) AS Duplicate_Count 
FROM order_items
GROUP BY order_id, 
order_item_id HAVING COUNT(*)>1;

/*
===========================================================
SUMMARY : ORDER_ITEMS TABLE
===========================================================

Business Objective:
Validate the completeness and integrity of order item data
before performing product, seller, revenue, and shipping
analysis.

-----------------------------------------------------------
Data Quality Findings
-----------------------------------------------------------

Total Records            : 112,650

Duplicate Order Items    : 0
Status                   : PASS

NULL Value Check

order_id                 : 0
order_item_id            : 0
product_id               : 0
seller_id                : 0
shipping_limit_date      : 0
price                    : 0
freight_value            : 0

Blank Value Check

order_id                 : 0
product_id               : 0
seller_id                : 0

Invalid Value Check

Negative Price           : 0
Negative Freight Value   : 0

-----------------------------------------------------------
Business Rule Validation
-----------------------------------------------------------

? Every order item has a valid order ID.
? Every order item is linked to a product and seller.
? No duplicate (order_id, order_item_id) combinations found.
? Product prices are valid (no negative values).
? Freight charges are valid (no negative values).

-----------------------------------------------------------
Business Observation
-----------------------------------------------------------

• The Order Items table is complete and contains no missing
  or duplicate records.

• Every order item is associated with a valid product and
  seller, making the table reliable for sales and inventory
  analysis.

• Product pricing and freight charges are logically valid,
  ensuring accurate revenue and shipping cost calculations.

-----------------------------------------------------------
Business Impact
-----------------------------------------------------------

The Order Items table is ready for business analysis and can
be confidently used for:

• Revenue Analysis
• Product Performance Analysis
• Seller Performance Analysis
• Shipping Cost Analysis
• Profitability Analysis
• Dashboard Reporting

-----------------------------------------------------------
Status
-----------------------------------------------------------

✅ DATA QUALITY CHECK PASSED

✅ READY FOR BUSINESS ANALYSIS

===========================================================
*/




/* ===========================================================
TABLE 4 : PRODUCTS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Total products
----------------------------------------------------------

SELECT COUNT(*) AS Total_products
FROM products;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- View sample products
----------------------------------------------------------

SELECT TOP 10 *
FROM products;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check NULL values
----------------------------------------------------------

SELECT

SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS category_nulls,
SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS name_lenght_nulls,
SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS description_lenght_nulls,
SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS photos_qty_nulls,
SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS weight_g_nulls,
SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS length_cm_nulls,
SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS height_cm_nulls,
SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS width_cm_nulls

FROM products;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check duplicate Orders
----------------------------------------------------------

SELECT
product_id,
COUNT(*) AS Duplicate_Count

FROM products

GROUP BY product_id

HAVING COUNT(*)>1;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- check invalid data
----------------------------------------------------------

select 
*
from products
where product_photos_qty <=0;

select 
*
from products
where product_weight_g <=0;

select 
*
from products
where product_length_cm <=0;

select 
*
from products
where product_height_cm <=0;

select 
*
from products
where product_width_cm <=0;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Verify that every product category has a corresponding
----------------------------------------------------------

SELECT
    p.product_id,
    p.product_category_name,
    ct.product_category_name_english
FROM products p
LEFT JOIN category_translation ct
ON p.product_category_name = ct.product_category_name;

/*
===========================================================
SUMMARY : PRODUCTS TABLE
===========================================================

Business Objective:
Validate the completeness and accuracy of product information
before performing product performance, category, and inventory
analysis.

-----------------------------------------------------------
Data Quality Findings
-----------------------------------------------------------

Total Records            : 32,951

Duplicate Product IDs    : 0
Status                   : PASS

NULL Value Check

product_id                    : 0
product_category_name         : 610
product_name_lenght           : 610
product_description_lenght    : 610
product_photos_qty            : 610
product_weight_g              : 2
product_length_cm             : 2
product_height_cm             : 2
product_width_cm              : 2

-----------------------------------------------------------
Invalid Value Check
-----------------------------------------------------------

Negative/Zero Product Photos  : 0
Negative/Zero Product Weight  : 4
Negative/Zero Product Length  : 0
Negative/Zero Product Height  : 0
Negative/Zero Product Width   : 0

-----------------------------------------------------------
Business Observation
-----------------------------------------------------------

• No duplicate Product IDs were found.

• A total of 610 products have missing category names,
  product names, descriptions, and photo quantities.
  These records likely represent incomplete product
  registrations.

• Two products have missing physical dimensions.

• Four products have a recorded weight of zero grams,
  which is not a valid business value and should be
  investigated during the data cleaning phase.

-----------------------------------------------------------
Business Impact
-----------------------------------------------------------

Missing product information may affect:

• Product Category Analysis
• Product Performance Analysis
• Dashboard Visualizations
• Inventory Reporting

Invalid product weight values may affect:

• Shipping Cost Analysis
• Freight Calculations
• Logistics Performance Analysis

These issues will be addressed during the Data Cleaning phase.

-----------------------------------------------------------
Status
-----------------------------------------------------------

✅ DATA CLEANING REQUIRED

===========================================================
*/



/* 
===========================================================
TABLE 5 : PAYMENTS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Total payments
----------------------------------------------------------

SELECT COUNT(*) AS Total_payments
FROM payments;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- View sample payments
----------------------------------------------------------

SELECT TOP 10 *
FROM payments;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check NULL values
----------------------------------------------------------
select
SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS sequential_nulls,
SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS payment_type_nulls,
SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS installments_nulls,
SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS values_nulls
from payments

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check duplicate payment records
----------------------------------------------------------

SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS Duplicate_Count
FROM payments
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- payment validation 
----------------------------------------------------------

SELECT *
FROM payments
WHERE payment_value <= 0;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- invalid payment installments 
----------------------------------------------------------

SELECT *
FROM payments
WHERE payment_installments <= 0;

----------------------------------------------------------
-- Investigate Payment Type Distribution
----------------------------------------------------------

select
payment_type,
count(*) as total_transactions
from payments
group by payment_type
order by total_transactions desc

/*
===========================================================
SUMMARY : PAYMENTS TABLE
===========================================================

Business Objective:
Validate the completeness and consistency of payment data
before performing payment method, revenue, and financial
analysis.

-----------------------------------------------------------
Data Quality Findings
-----------------------------------------------------------

Total Records            : 103,886

Duplicate Payment Records: 0
Status                   : PASS

NULL Value Check

order_id                 : 0
payment_sequential       : 0
payment_type             : 0
payment_installments     : 0
payment_value            : 0

-----------------------------------------------------------
Invalid Value Check
-----------------------------------------------------------

Payment Value <= 0       : 9 records
Payment Installments <=0 : 2 records

-----------------------------------------------------------
Business Observation
-----------------------------------------------------------

• The Payments table contains no missing values.

• No duplicate payment transactions were found.

• Nine payment records have a payment value of zero.
  These are associated with payment types such as
  'voucher' and 'not_defined' and may represent valid
  business scenarios rather than data quality issues.

• Two payment records contain zero installments,
  which is not a standard business rule and should
  be reviewed during the Data Cleaning phase.

-----------------------------------------------------------
Business Impact
-----------------------------------------------------------

The Payments table is suitable for payment method analysis,
revenue reporting, installment analysis, and financial
dashboard development.

However, payment records with zero installments should be
investigated before final reporting to ensure accurate
financial analysis.

-----------------------------------------------------------
Status
-----------------------------------------------------------
✅ MINOR DATA CLEANING REQUIRED

===========================================================
*/



/* 
===========================================================
TABLE 6 : REVIEWS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Total reviews
----------------------------------------------------------

SELECT COUNT(*) AS Total_reviews
FROM reviews;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- View sample reviews
----------------------------------------------------------

SELECT TOP 10 *
FROM reviews;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check NULL values
----------------------------------------------------------
select
SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS review_id_nulls,
SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS review_score_nulls,
SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS comment_title_nulls,
SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS comment_message_nulls,
SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS creation_nulls,
SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS answer_timestamp_nulls
from reviews;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check duplicate reviews
----------------------------------------------------------

SELECT
    review_id,
    order_id,
    COUNT(*) AS duplicate_count
FROM reviews
GROUP BY
    review_id,
    order_id
HAVING COUNT(*) > 1;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Validate review timeline
----------------------------------------------------------

SELECT *
FROM reviews
WHERE review_answer_timestamp < review_creation_date;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check review score
----------------------------------------------------------

select 
review_id,
review_score
from reviews
where review_score not between 1 and 5

/*
===========================================================
SUMMARY : REVIEWS TABLE
===========================================================

Business Objective:
Validate the completeness, consistency, and integrity of the
customer reviews dataset before using it for customer
satisfaction and review analysis.

-----------------------------------------------------------
Data Quality Findings
-----------------------------------------------------------

Total Records                    : 99,224

-----------------------------------------------------------
NULL Value Check
-----------------------------------------------------------

review_id                        : 0
order_id                         : 0
review_score                     : 0
review_comment_title             : 87,658
review_comment_message           : 58,256
review_creation_date             : 0
review_answer_timestamp          : 0

-----------------------------------------------------------
Duplicate Record Check
-----------------------------------------------------------

Duplicate Review-Order Records   : 0

Observation:
No duplicate review-order records were found.
Each review-order combination is unique.

-----------------------------------------------------------
Business Validation
-----------------------------------------------------------

? Review Timeline Validation      : PASSED
  - No review answer timestamp was found before the
    review creation date.

? Review Score Validation         : PASSED
  - All review scores are within the valid range (1 to 5).

-----------------------------------------------------------
Business Observation
-----------------------------------------------------------

• A large number of reviews do not contain a review title
  or review message.

• This is an expected business scenario because customers
  can submit only a star rating without writing a review.

• Review scores are complete and reliable for customer
  satisfaction analysis.

• The review dataset maintains good referential integrity
  and is suitable for business reporting.

-----------------------------------------------------------
Business Impact
-----------------------------------------------------------

The Reviews table is ready to support:

• Customer Satisfaction Analysis
• Product Rating Analysis
• Seller Performance Evaluation
• Review Score Distribution
• Customer Experience Dashboard

Text-based review analysis should consider that many
customers provided ratings without written comments.

-----------------------------------------------------------
Status
-----------------------------------------------------------

✅ DATA QUALITY CHECK PASSED

✅ READY FOR BUSINESS ANALYSIS

===========================================================
*/

/* 
===========================================================
TABLE 7 :sellers
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Total sellers
----------------------------------------------------------

SELECT COUNT(*) AS Total_sellers
FROM sellers;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- View sample sellers;
----------------------------------------------------------

SELECT TOP 10 *
FROM sellers;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check NULL values
----------------------------------------------------------
select
SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls,
SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zip_code_nulls,
SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS seller_city_nulls,
SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS seller_state_nulls
from sellers;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check duplicate sellers
----------------------------------------------------------

SELECT
seller_id,
COUNT(*) AS Duplicate_Count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*)>1;

----------------------------------------------------------
-- BUSINESS PURPOSE:
--Check for blank values in text columns
----------------------------------------------------------

select *
from sellers
where seller_city='';

select*
from sellers 
where seller_state='';

/*
===========================================================
SUMMARY : SELLERS TABLE
===========================================================

Business Objective:
Validate the completeness and accuracy of seller information
before performing seller performance, geographic distribution,
and fulfillment analysis.

-----------------------------------------------------------
Data Quality Findings
-----------------------------------------------------------

Total Records            : 3,095

Duplicate Seller IDs     : 0
Status                   : PASS

NULL Value Check

seller_id                : 0
seller_zip_code_prefix   : 0
seller_city              : 0
seller_state             : 0

Blank Value Check

seller_city              : 0
seller_state             : 0

-----------------------------------------------------------
Business Rule Validation
-----------------------------------------------------------

? Every seller has a unique seller ID.
? No duplicate seller records were found.
? No NULL values exist in any seller column.
? No blank values were found in seller_city or seller_state.

-----------------------------------------------------------
Business Observation
-----------------------------------------------------------

• The Sellers table is complete and contains no missing
  or duplicate records.

• Every seller record includes valid geographic information,
  making the dataset reliable for regional and state-level
  seller analysis.

• The data is suitable for evaluating seller performance,
  delivery efficiency, and marketplace coverage.

-----------------------------------------------------------
Business Impact
-----------------------------------------------------------

The Sellers table is ready for business analysis and can
be confidently used for:

• Seller Performance Analysis
• State-wise Seller Distribution
• Regional Sales Analysis
• Marketplace Coverage Analysis
• Dashboard Reporting

-----------------------------------------------------------
Status
-----------------------------------------------------------

✅ DATA QUALITY CHECK PASSED

✅ READY FOR BUSINESS ANALYSIS

===========================================================
*/


/* 
===========================================================
TABLE 8 : CATEGORY TRANSLACTION
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Total category_translation
----------------------------------------------------------

SELECT COUNT(*) AS Total_category_translation
FROM category_translation;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- View sample category_translation;
----------------------------------------------------------

SELECT TOP 10 *
FROM category_translation;
----------------------------------------------------------
-- BUSINESS PURPOSE:
-- columns name 
----------------------------------------------------------

EXEC sp_rename
'category_translation.column1',
'product_category_name',
'COLUMN';

EXEC sp_rename
'category_translation.column2',
'product_category_name_english',
'COLUMN';

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check for blank values in text columns
----------------------------------------------------------
select 
*
from category_translation
where product_category_name ='';

select 
*
from category_translation
where product_category_name_english ='';

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- clecking th mixing value in columns
----------------------------------------------------------

select 
*
from category_translation
where product_category_name is null ;

select 
*
from category_translation
where product_category_name_english is null;


/*
===========================================================
SUMMARY : CATEGORY_TRANSLATION TABLE
===========================================================

Business Objective:
Validate the completeness and correctness of product category
translation data before using it for category-level reporting
and English dashboard visualization.

-----------------------------------------------------------
Data Quality Findings
-----------------------------------------------------------

Total Records                    : 72

Duplicate Category Names         : 0
Status                           : PASS

Schema Validation

? Column names successfully renamed:

column1  ? product_category_name
column2  ? product_category_name_english

-----------------------------------------------------------
NULL Value Check
-----------------------------------------------------------

product_category_name            : 0
product_category_name_english    : 0

-----------------------------------------------------------
Blank Value Check
-----------------------------------------------------------

product_category_name            : 0
product_category_name_english    : 0

-----------------------------------------------------------
Business Observation
-----------------------------------------------------------

• The Category Translation table contains all product
  categories with their corresponding English translations.

• No missing or blank values were found.

• The table is complete and can be safely joined with the
  Products table to generate English category names in
  dashboards and reports.

-----------------------------------------------------------
Business Impact
-----------------------------------------------------------

The Category Translation table is ready for analysis and can
be confidently used for:

• Product Category Analysis
• Sales by Category
• Product Dashboard Reporting
• English Category Labels
• Business Intelligence Dashboards

-----------------------------------------------------------
Status
-----------------------------------------------------------

✅ DATA QUALITY CHECK PASSED

✅ READY FOR BUSINESS ANALYSIS

===========================================================
*/

/* 
===========================================================
TABLE 9 : GEOLOCATION 
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Total geolocation
----------------------------------------------------------

SELECT COUNT(*) AS Total_geolocation
FROM geolocation;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- View sample geolocation;
----------------------------------------------------------

SELECT TOP 10 *
FROM geolocation;


----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check NULL values
----------------------------------------------------------
SELECT
    SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zip_nulls,
    SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) AS lat_nulls,
    SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) AS lng_nulls,
    SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) AS state_nulls
FROM geolocation;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check duplicate geolocation records
----------------------------------------------------------

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS Duplicate_Count
FROM geolocation
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Check for blank values in text columns
----------------------------------------------------------
select *
from geolocation
where geolocation_city =''

select *
from geolocation
where geolocation_state ='';

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- validation check
----------------------------------------------------------

SELECT *
FROM geolocation
WHERE geolocation_lat NOT BETWEEN -90 AND 90;


SELECT *
FROM geolocation
WHERE geolocation_lng NOT BETWEEN -180 AND 180;

/*
===========================================================
SUMMARY : GEOLOCATION TABLE
===========================================================

Business Objective:
Validate the completeness and accuracy of geographic location
data before performing location-based sales, customer,
and logistics analysis.

-----------------------------------------------------------
Data Quality Findings
-----------------------------------------------------------

Total Records                 : 1,000,163

Duplicate Records             : 0
Status                        : PASS

NULL Value Check

geolocation_zip_code_prefix   : 0
geolocation_lat               : 0
geolocation_lng               : 0
geolocation_city              : 0
geolocation_state             : 0

Blank Value Check

geolocation_city              : 0
geolocation_state             : 0

-----------------------------------------------------------
Business Rule Validation
-----------------------------------------------------------

? Every record contains valid geographic coordinates.
? No missing ZIP codes, cities, or states were found.
? Geographic information is complete and suitable for
  regional analysis.

-----------------------------------------------------------
Business Observation
-----------------------------------------------------------

• The Geolocation table contains over one million
  geographic records representing ZIP code locations
  across Brazil.

• No missing values were detected.

• The dataset is complete and can be used for mapping,
  regional sales analysis, logistics optimization,
  and customer distribution analysis.

-----------------------------------------------------------
Business Impact
-----------------------------------------------------------

The Geolocation table is ready for business analysis and
can be confidently used for:

• Customer Geographic Analysis
• Seller Distribution Analysis
• Delivery Route Analysis
• Regional Sales Analysis
• Interactive Maps and Dashboards

-----------------------------------------------------------
Status
-----------------------------------------------------------

✅ DATA QUALITY CHECK PASSED

✅ READY FOR BUSINESS ANALYSIS

===========================================================
*/