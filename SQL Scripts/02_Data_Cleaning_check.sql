/*
===========================================================
TABLE 1: CUSTOMERS 
===========================================================
----------------------------------------------------------
CLEANING DECISION
----------------------------------------------------------

Observation:
No missing values, duplicate records, or blank values were
identified.

Cleaning Action:
No cleaning required.

Reason:
The Customers table is complete, consistent, and ready for
business analysis.

Status:
✅ READY FOR ANALYSIS
----------------------------------------------------------
*/

SELECT *
FROM customers;


/*
===========================================================
TABLE 2 : ORDERS 
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify order statuses with missing approval dates
-- to determine whether the NULL values represent valid
-- business scenarios or require data cleaning.
----------------------------------------------------------

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_approved_at IS NULL
GROUP BY order_status;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify order statuses with missing carrier delivery
-- dates to verify whether the missing values are expected
-- based on the order lifecycle.
----------------------------------------------------------

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_delivered_carrier_date IS NULL
GROUP BY order_status;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify order statuses with missing customer delivery
-- dates to determine whether these orders were cancelled,
-- unavailable, or still in progress.
----------------------------------------------------------

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Review the distribution of order statuses to understand
-- the overall order lifecycle and support data cleaning
-- decisions for missing delivery-related dates.
----------------------------------------------------------

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

/*
===========================================================
CLEANING DECISION : ORDERS TABLE
===========================================================

Observation:

• Missing approval dates were found for:
  - 141 Cancelled orders
  - 5 Created orders
  - 14 Delivered orders

• Missing carrier delivery dates were found mainly for
  orders that had not reached the shipping stage.
  Only 2 Delivered orders had missing carrier dates.

• Missing customer delivery dates were found mainly for
  Cancelled, Unavailable and Shipped orders.
  Only 8 Delivered orders had missing delivery dates.

Cleaning Action:

No records were updated.

Business Justification:

• NULL values for Cancelled, Created, Processing,
  Invoiced, Unavailable and Shipped orders represent
  valid business scenarios.

• Although a small number of Delivered orders have
  missing dates, the correct values cannot be inferred.
  Updating these records would introduce inaccurate data.

Decision:

The original values are retained and the affected records
are documented for reporting purposes.

Status:

✅ DATA REVIEWED
✅ READY FOR ANALYSIS

===========================================================
*/

/*
===========================================================
TABLE 3 : ORDER ITEMS
===========================================================
----------------------------------------------------------
CLEANING DECISION
----------------------------------------------------------

Observation:
No missing values, duplicate records, or invalid values
were identified.

Cleaning Action:
No cleaning required.

Reason:
The Order Items table is complete and suitable for
business analysis.

Status:
✅ READY FOR ANALYSIS
===========================================================
*/

SELECT *
FROM order_items;

/* 
===========================================================
TABLE 4 : PRODUCTS 
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify products with missing category names to
-- determine whether category information needs to be
-- completed before business analysis.
----------------------------------------------------------

SELECT *
FROM products
WHERE product_category_name IS NULL;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify products with missing product name length
-- values to evaluate data completeness.
----------------------------------------------------------

SELECT *
FROM products
WHERE product_name_lenght IS NULL;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify products with missing description length
-- values to determine whether product descriptions are
-- incomplete.
----------------------------------------------------------

SELECT *
FROM products
WHERE product_description_lenght IS NULL;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify products with missing photo quantity values
-- to verify the completeness of product information.
----------------------------------------------------------

SELECT *
FROM products
WHERE product_photos_qty IS NULL;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify products with missing physical dimensions,
-- including weight, length, height, and width, before
-- performing product-related analysis.
----------------------------------------------------------

SELECT *
FROM products
WHERE product_weight_g IS NULL
   OR product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify products with invalid weight values
-- (less than or equal to zero), which may indicate
-- incorrect or incomplete product information.
----------------------------------------------------------

SELECT *
FROM products
WHERE product_weight_g <= 0;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify product categories that do not have a matching
-- English translation, ensuring all categories can be
-- displayed correctly in business reports and dashboards.
----------------------------------------------------------

SELECT
    p.product_id,
    p.product_category_name
FROM products p
LEFT JOIN category_translation ct
ON p.product_category_name = ct.product_category_name
WHERE ct.product_category_name IS NULL;



/*
----------------------------------------------------------
CLEANING DECISION
----------------------------------------------------------

Observation:
Missing values were found in category, product name,
description, photo quantity, and product dimensions.
A few products also contain invalid weight values.

Cleaning Action:
No records were modified at this stage.

Reason:
The identified records require business validation before
deciding whether to update, remove, or retain them.
Category translations were also verified to ensure proper
reporting.

Status:
⚠ REQUIRES FURTHER INVESTIGATION
----------------------------------------------------------
*/

/* 
===========================================================
TABLE 5 : PAYMENTS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify payment records with zero payment values to
-- determine whether they represent valid business
-- transactions or require further investigation.
----------------------------------------------------------

SELECT *
FROM payments
WHERE payment_value = 0;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify payment records with zero installment values
-- to verify whether they are valid payment transactions
-- or potential data quality issues.
----------------------------------------------------------

select*
from payments
where  payment_installments = 0 

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Analyze payment methods associated with zero payment
-- values to determine whether specific payment types
-- contribute to these records.
----------------------------------------------------------

SELECT
    payment_type,
    COUNT(*) AS total_records
FROM payments
WHERE payment_value = 0
GROUP BY payment_type;

/*
----------------------------------------------------------
CLEANING DECISION
----------------------------------------------------------

Observation:
Payment records with zero payment values and zero
installments were identified.

Cleaning Action:
No records were modified.

Reason:
These records require business validation to determine
whether they represent valid transactions or data quality
issues.

Status:
⚠ REQUIRES FURTHER INVESTIGATION
----------------------------------------------------------
*/

/* 
===========================================================
TABLE 6 : REVIEWS
===========================================================
*/

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify customer reviews with missing review titles
-- to determine whether the missing values represent
-- optional customer input or require cleaning.
----------------------------------------------------------

SELECT *
FROM reviews
WHERE review_comment_title IS NULL;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Identify customer reviews with missing review messages
-- to evaluate whether the missing values are expected
-- based on customer review behavior.
----------------------------------------------------------

SELECT *
FROM reviews
WHERE review_comment_message IS NULL;

/*
----------------------------------------------------------
CLEANING DECISION
----------------------------------------------------------

Observation:
Many reviews contain NULL values in review titles and
review messages.

Cleaning Action:
No cleaning required.

Reason:
Providing a review title or message is optional for
customers. These NULL values represent expected customer
behavior and should be preserved.

Status:
✅ READY FOR ANALYSIS
----------------------------------------------------------
*/


/* 
===========================================================
TABLE 7 : SELLERS
===========================================================
----------------------------------------------------------
CLEANING DECISION
----------------------------------------------------------

Observation:
No missing values, duplicate records, or blank values
were identified.

Cleaning Action:
No cleaning required.

Reason:
The Sellers table is complete and ready for business
analysis.

Status:
✅ READY FOR ANALYSIS
===========================================================
*/

SELECT *
FROM sellers;


/* 
===========================================================
TABLE 8 : CATEGORY TRANSLATION
===========================================================
----------------------------------------------------------
CLEANING DECISION
----------------------------------------------------------

Observation:
No missing values or duplicate category translations
were identified.

Cleaning Action:
No cleaning required.

Reason:
The Category Translation table is complete and can be
used to display English category names in reports and
dashboards.

Status:
✅ READY FOR ANALYSIS
===========================================================
*/

SELECT *
FROM category_translation;

/* 
===========================================================
TABLE 9 : GEOLOCATION
===========================================================
----------------------------------------------------------
CLEANING DECISION
----------------------------------------------------------

Observation:
No missing values or invalid geographic coordinates were
identified during the cleaning assessment.

Cleaning Action:
No cleaning required.

Reason:
The Geolocation table is complete and suitable for
location-based analysis.

Status:
✅ READY FOR ANALYSIS
===========================================================
*/


SELECT *
FROM geolocation;


