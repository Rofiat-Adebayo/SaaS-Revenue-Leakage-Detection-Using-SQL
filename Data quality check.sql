

/* DUPLICATE DISCOUNTS PER BILLING RECORD

   Purpose:
   Identify billing records that have more than one discount
   record associated with them*/.
   

SELECT
    billing_id,
    COUNT(*) AS discount_count
FROM Discounts
WHERE billing_id IS NOT NULL
GROUP BY billing_id
HAVING COUNT(*) > 1;


/* 2. DISCOUNTS WITHOUT A BILLING RECORD

   Purpose:
   Identify discount records that are not linked to a billing
   record.*/

SELECT *
FROM Discounts
WHERE billing_id IS NULL;


/*
   3. DUPLICATE BILLING RECORDS

   Purpose:
   Identify potential duplicate billing records for the same
   customer, subscription, product, and billing period.*/

SELECT
    customer_id,
    subscription_id,
    product_id,
    billing_cycle_start,
    billing_cycle_end,
    COUNT(*) AS billing_record_count
FROM Billing
GROUP BY
    customer_id,
    subscription_id,
    product_id,
    billing_cycle_start,
    billing_cycle_end
HAVING COUNT(*) > 1;


/* INVALID DISCOUNT PERCENTAGES

   Purpose:
   Confirm that discount percentages fall within the valid
   range of 0% to 100%. */

SELECT
    discount_id,
    customer_id,
    product_id,
    discount_percentage
FROM Discounts
WHERE discount_percentage < 0
   OR discount_percentage > 100;


/* INVALID FINANCIAL AMOUNTS

   Purpose:
   Identify negative values in key financial fields.

   Negative amounts are treated as invalid for this project's
   sample data and business assumptions. */

SELECT
    billing_id,
    customer_id,
    expected_amount,
    billed_amount
FROM Billing
WHERE expected_amount < 0
   OR billed_amount < 0;


SELECT
    discount_id,
    customer_id,
    discount_amount
FROM Discounts
WHERE discount_amount < 0;


/* INVALID DATE RELATIONSHIPS

   Purpose:
   Identify dates that do not follow the expected chronological
   order.

   Expected relationships:
   - Billing cycle end >= billing cycle start
   - Bill date >= billing cycle start
   - Due date >= bill date
   - Payment date >= bill date */

SELECT
    billing_id,
    customer_id,
    billing_cycle_start,
    billing_cycle_end,
    bill_date,
    due_date,
    payment_date
FROM Billing
WHERE billing_cycle_end < billing_cycle_start
   OR bill_date < billing_cycle_start
   OR due_date < bill_date
   OR payment_date < bill_date;