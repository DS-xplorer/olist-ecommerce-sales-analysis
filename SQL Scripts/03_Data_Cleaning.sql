/*
===========================================================
DATA CLEANING : PRODUCT TABLE
===========================================================
*/

-----------------------------------------------------------
-- Create cleaned copy of Products table
-----------------------------------------------------------

SELECT *
INTO products_cleaned
FROM products;


-----------------------------------------------------------
-- Product Category name 
-----------------------------------------------------------

SELECT *
FROM products_cleaned
WHERE product_category_name IS NULL;


update products_cleaned
set product_category_name='unknown'
where product_category_name is null;

/*
Business Decision:
Updated missing product category names to 'Unknown'.

Reason:
Product categories are required for category-level analysis
and reporting. Replacing NULL values with 'Unknown' ensures
that products with missing categories remain included in
reports without being excluded from aggregations.
*/


----------------------------------------------------------
-- Replace invalid product weights with NULL
----------------------------------------------------------

UPDATE products_cleaned
SET product_weight_g = NULL
WHERE product_weight_g <= 0;

/*
Business Decision:
Updated invalid product weights (less than or equal to zero)
to NULL.

Reason:
A product cannot have a weight of zero or a negative value.
These values are considered invalid and were replaced with
NULL to indicate that the actual weight is unknown while
preserving data integrity for future analysis.
*/

/*
===========================================================
DATA CLEANING : PAYMENTS TABLE
===========================================================
*/

-----------------------------------------------------------
-- Create cleaned copy of Payments table
-----------------------------------------------------------

SELECT *
INTO payments_cleaned
FROM payments;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Verify whether zero-installment records are credit card
-- payments that require correction.
----------------------------------------------------------

SELECT *
FROM payments_cleaned
WHERE payment_installments = 0;

----------------------------------------------------------
-- BUSINESS PURPOSE:
-- Correct invalid credit card installment values.
----------------------------------------------------------

UPDATE payments_cleaned
SET payment_installments = 1
WHERE payment_type = 'credit_card'
  AND payment_installments = 0;

 /*
Business Decision:
Updated payment_installments from 0 to 1.

Reason:
Credit card payments cannot have zero installments.
The affected records contained valid payment values,
indicating that the installment value was incorrectly
stored as 0. Replacing it with 1 preserves the business
meaning of a single-payment transaction.
*/


/*
===========================================================
DATA CLEANING : REVIEWS TABLE
===========================================================
*/

-----------------------------------------------------------
-- Create cleaned copy of Reviews table
-----------------------------------------------------------

SELECT *
INTO reviews_cleaned
FROM reviews;

----------------------------------------------------------
-- Replace missing review titles
----------------------------------------------------------

UPDATE reviews_cleaned
SET review_comment_title = 'No Title'
WHERE review_comment_title IS NULL;

/*
Business Decision:
Updated missing review titles with 'No Title'.

Reason:
Review titles are optional in the Olist dataset. Replacing
NULL values with 'No Title' improves data readability while
preserving all review records for reporting and analysis.
*/

----------------------------------------------------------
-- Replace missing review messages
----------------------------------------------------------

UPDATE reviews_cleaned
SET review_comment_message = 'No Comment'
WHERE review_comment_message IS NULL;

/*
Business Decision:
Updated missing review messages with 'No Comment'.

Reason:
Review comments are optional customer inputs. Replacing
NULL values with 'No Comment' improves consistency in the
dataset without affecting review scores or business
analysis.
*/
