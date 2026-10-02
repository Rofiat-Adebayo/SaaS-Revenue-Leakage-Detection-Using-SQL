# SaaS-Revenue-Leakage-Detection-Using-SQL
A SQL-based revenue assurance project designed to identify potential revenue leakage in a SaaS business by analysing under-billing, excessive discounts, product usage discrepancies, and overdue payments.

## Executive Summary

Revenue leakage can occur when a SaaS business does not collect the full revenue it is contractually or operationally entitled to receive. This project applies SQL Server to investigate potential revenue leakage across customer billing, subscriptions, discounts, product usage, and payments.

The analysis focuses on five key areas:

- Identifying customers who have been under-billed
- Detecting discounts that exceed approved thresholds
- Comparing customer usage with included product allowances
- Identifying outstanding or overdue invoices
- Consolidating the findings into an overall revenue leakage summary

A relational database was designed using six interconnected tables: `Customers`, `Products`, `Subscriptions`, `Billing`, `Discounts`, and `Product_Usage`. SQL queries were then developed using joins, aggregations, conditional logic, date filtering, set operations, and data-quality checks to transform the underlying records into business-focused insights.

The final analysis provides a consolidated view of potential financial exposure, including the amount associated with under-billing, excessive discounts, and missed payments, as well as the number of unique customers affected.

The project demonstrates how SQL can be used not only to retrieve data, but also to support **revenue assurance, financial controls, and data-driven business decision-making**.

## Key Results

The final revenue leakage analysis identified **£2,124.00 in potential revenue leakage** across the three financial leakage categories analysed during the June–August 2026 review period.

| Revenue Leakage Category | Potential Leakage |
| ------------------------ | -----------------:|
| Under-billing | £710.00 |
| Excessive Discounts | £214.00 |
| Missed Payments | £1,200.00 |
| **Total Potential Revenue Leakage** | **£2,124.00** |

### Customers Affected

**7 unique customers** were identified across the three revenue leakage categories.

### Key Findings

- **£710.00** of potential leakage was identified from customers being billed below the expected amount.
- **£214.00** was associated with discounts exceeding the approved product-level discount thresholds.
- **£1,200.00** was identified from missed or overdue payments.
- **7 unique customers** were affected across the identified leakage categories.
- Missed payments represented the **largest identified component** of potential leakage, accounting for approximately **56.5%** of the total.
- Overall, the analysis identified **£2,124.00 in potential financial exposure** requiring further investigation.

> **Note:** The figures represent potential revenue leakage identified from the sample data using the defined business rules.

## Business Problem

Revenue leakage is a significant challenge for SaaS businesses because revenue can be lost when billing does not accurately reflect customer contracts, approved pricing, product usage, and payment activity.

For this project, the business has customer subscription, billing, discount, product usage, and payment data stored across related tables. However, without targeted analysis, it can be difficult to identify where potential revenue is being lost and which customers are affected.

The objective of this project is to use SQL to investigate four key sources of potential revenue leakage:

- Customers being billed below their expected or contracted amounts
- Discounts exceeding the maximum threshold allowed for a product
- Customers using more of a product than their included allowance
- Invoices that remain unpaid after their due date

The analysis then consolidates the identified financial exposure into an executive revenue leakage summary, allowing the business to understand the scale and sources of potential leakage within the three-month review period.

## Business Questions

The analysis was designed to answer the following business questions:

1. **Under-billing:** Which customers were under-billed during the June–August 2026 review period, and what was the potential under-billed amount?

2. **Excessive Discounts:** Which customers received discounts above the maximum discount threshold permitted for their products, and what was the potential excess discount amount?

3. **Usage Discrepancies:** Which customers used more of their product allowance than was included in their subscription?

4. **Outstanding Payments:** Which customers had unpaid or overdue invoices, and what was the value of the outstanding payments?

5. **Overall Revenue Leakage:** What was the total potential revenue leakage across under-billing, excessive discounts, and missed payments, and how many unique customers had at least one potential leakage issue?

## Review Period & Assumptions

### Review Period

The analysis covers a three-month period from **June 1, 2026 to August 31, 2026**.

### Assumptions

The following business rules and assumptions were applied throughout the analysis:

- **Under-billing:** A billing record is considered under-billed when `billed_amount` is less than `expected_amount`. The potential under-billed amount is calculated as `expected_amount - billed_amount`.

- **Contracted Price:** `contracted_price` represents the final agreed customer price for a subscription. A difference between the product's standard price and contracted price is not automatically treated as revenue leakage.

- **Excessive Discounts:** A discount is considered excessive when `discount_percentage` exceeds the product's `max_discount_pct`. Only the portion above the permitted discount threshold is treated as potential leakage.

- **Usage Discrepancy:** A potential usage discrepancy exists when a customer's `active_users` exceed the `included_users` specified for the product.

- **Outstanding/Overdue Payments:** An invoice is considered unpaid when `payment_date` is `NULL`. An invoice is considered overdue when its `due_date` has passed and no payment has been recorded.

- **Customers Affected:** Customers affected represents the number of **unique customers** with at least one potential revenue leakage issue across the analysed categories.

- **Potential Leakage:** The results represent potential revenue leakage identified from the sample data using the defined business rules.


## Data Model

The project uses a relational data model consisting of six interconnected tables:
`Customers`, `Products`, `Subscriptions`, `Billing`, `Discounts`, and `Product_Usage`.

### Entity Relationship Diagram

<img width="1890" height="999" alt="Untitled (1)" src="https://github.com/user-attachments/assets/0069591c-fa94-4273-87a1-21a242c33f21" />



### Table Overview

| Table | Purpose |
|---|---|
| `Customers` | Stores customer information |
| `Products` | Stores product pricing and limits |
| `Subscriptions` | Stores customer subscriptions and contracted prices |
| `Billing` | Stores billing and payment information |
| `Discounts` | Stores customer discounts |
| `Product_Usage` | Stores customer product usage |

### Key Relationships

The relationships between the tables were designed to maintain referential integrity and allow billing, subscription, discount, usage, and payment data to be analysed together.

- **Customers → Subscriptions:**  
  A customer can have one or more subscriptions. Each subscription belongs to one customer through `customer_id`.

- **Products → Subscriptions:**  
  A product can be subscribed to by multiple customers. Each subscription is linked to one product through `product_id`.

- **Subscriptions → Billing:**  
  A subscription can generate multiple billing records over time. Each billing record is linked to the subscription through `subscription_id`.

- **Customers → Billing:**  
  Each billing record belongs to a customer through `customer_id`, allowing revenue and payment activity to be analysed by customer.

- **Products → Billing:**  
  Each billing record identifies the product being billed through `product_id`.

- **Customers → Discounts:**  
  A customer can receive multiple discounts. Each discount is associated with a customer through `customer_id`.

- **Products → Discounts:**  
  Discounts are linked to the relevant product through `product_id`, allowing the actual discount to be compared with the product's maximum permitted discount.

- **Billing → Discounts:**  
  A discount can optionally be linked to a specific billing record through `billing_id`.

- **Customers → Product_Usage:**  
  A customer can have multiple usage records over time. Each usage record identifies the customer through `customer_id`.

- **Products → Product_Usage:**  
  Usage records are linked to the product being used through `product_id`.

- **Subscriptions → Product_Usage:**  
  Usage records are linked to the relevant subscription through `subscription_id`, allowing actual usage to be compared with the customer's subscribed product and included allowance.

  # Data Dictionary

This data dictionary defines the key tables and fields used in the SaaS Revenue Leakage Detection project.

## Customers

| Column | Definition |
|---|---|
| `customer_id` | Unique identifier for each customer |
| `customer_name` | Name of the customer |
| `customer_type` | Customer segment, such as Enterprise, Mid-Market, or Small Business |
| `email` | Customer email address |
| `phone` | Customer contact number |
| `country` | Customer's country |
| `activation_date` | Date the customer became active |
| `customer_status` | Current status of the customer |

## Products

| Column | Definition |
|---|---|
| `product_id` | Unique identifier for each product |
| `product_name` | Name of the SaaS product or plan |
| `pricing_model` | Pricing structure used for the product |
| `standard_price` | Standard listed price before customer-specific pricing or discounts |
| `billing_frequency` | Frequency at which the product is billed |
| `included_users` | Number of users included in the product plan |
| `extra_user_price` | Price charged for users above the included allowance |
| `max_discount_pct` | Maximum discount percentage permitted for the product |
| `product_status` | Current status of the product |

## Subscriptions

| Column | Definition |
|---|---|
| `subscription_id` | Unique identifier for each subscription |
| `customer_id` | Customer associated with the subscription |
| `product_id` | Product associated with the subscription |
| `subscription_start_date` | Date the subscription started |
| `subscription_end_date` | Date the subscription ended, if applicable |
| `subscription_status` | Current status of the subscription |
| `contracted_price` | Final agreed price for the customer's subscription |
| `billing_frequency` | Frequency at which the customer is billed |

## Billing

| Column | Definition |
|---|---|
| `billing_id` | Unique identifier for each billing record |
| `customer_id` | Customer associated with the billing record |
| `subscription_id` | Subscription associated with the billing record |
| `product_id` | Product being billed |
| `billing_cycle_start` | Start date of the billing period |
| `billing_cycle_end` | End date of the billing period |
| `expected_amount` | Amount that should have been billed |
| `billed_amount` | Amount actually billed |
| `bill_date` | Date the invoice was issued |
| `due_date` | Date payment was due |
| `payment_date` | Date payment was received, if recorded |
| `payment_status` | Current payment status of the invoice |

## Discounts

| Column | Definition |
|---|---|
| `discount_id` | Unique identifier for each discount |
| `customer_id` | Customer receiving the discount |
| `product_id` | Product to which the discount applies |
| `billing_id` | Billing record associated with the discount, where applicable |
| `discount_type` | Type or reason for the discount |
| `discount_percentage` | Percentage discount applied |
| `discount_amount` | Monetary value of the discount |
| `discount_date` | Date the discount was applied |
| `discount_status` | Current status of the discount |

## Product_Usage

| Column | Definition |
|---|---|
| `usage_id` | Unique identifier for each usage record |
| `customer_id` | Customer associated with the usage record |
| `product_id` | Product being used |
| `subscription_id` | Subscription associated with the usage |
| `usage_month` | Month in which usage was recorded |
| `active_users` | Number of active users recorded for the customer |
| `included_users` | Number of users included in the customer's plan |
| `usage_units` | Quantity of product usage recorded |
| `recorded_date` | Date the usage record was captured |


## Data Quality Checks

Before performing the revenue leakage analysis, a series of data quality checks were carried out to identify issues that could affect the accuracy and interpretation of the results.

The checks focused on duplicate records, missing relationships, invalid financial values, and inconsistent dates.

| Check | Purpose |
|---|---|
| Duplicate discounts per billing record | Ensures a billing record does not contain multiple discount records where only one is expected |
| Discounts without a billing record | Identifies discounts that cannot be traced to a billing event |
| Duplicate billing records | Identifies potential duplicate billing entries for the same customer, subscription, and billing period |
| Invalid discount percentages | Confirms discount percentages fall between 0% and 100% |
| Invalid financial amounts | Identifies negative or otherwise invalid billing and discount amounts |
| Invalid date relationships | Checks that billing periods, invoice dates, due dates, and payment dates follow logical chronological order |

### Results

| Data Quality Check | Result |
|---|---:|
| Duplicate discounts per billing record | 0 |
| Discounts without billing record | 0 |
| Duplicate billing records | 0 |
| Invalid discount percentages | 0 |
| Invalid financial amounts | 0 |
| Invalid date relationships | 0 |

The checks confirmed that no data quality issues were identified in the sample data that would prevent the revenue leakage analysis from being performed.

## SQL Analysis

The SQL analysis translates the business questions into measurable revenue leakage indicators using SQL Server. Each analysis focuses on a specific leakage area and produces a result that can be reviewed independently before being consolidated into the final revenue leakage summary.

### 1. Under-billing Analysis

**Business Question**

Which customers were under-billed during the June–August 2026 review period, and what was the potential under-billed amount?

**Analysis Logic**

A billing record is considered under-billed when the `billed_amount` is less than the `expected_amount`.

```text
Potential Under-billing = Expected Amount - Billed Amount
```

The analysis identified 4 customers with potential under-billing, resulting in a combined potential shortfall of £710.00 during the review period.



---

### 2. Excessive Discount Analysis

```markdown
### 2. Excessive Discount Analysis

**Business Question**

Which customers received discounts above the maximum discount threshold permitted for their products?

**Analysis Logic**

A discount is considered excessive when:

```text
Discount Percentage > Maximum Allowed Discount Percentage
```

The analysis compares discount_percentage against the product-level max_discount_pct and calculates the portion of the discount that exceeds the permitted threshold.


### Key Finding

The analysis identified 4 customers with discounts above the permitted product-level threshold, representing £214.00 in potential excessive discount leakage.


---


### 3. Usage vs Billing Analysis

**Business Question**

Which customers are using more of their product allowance than is included in their subscription?

**Analysis Logic**

A potential usage discrepancy exists when:

```text
Active Users > Included Users
```

The analysis compares ```active_users``` with the ```included_users``` allowance associated with each customer's product subscription.

```/*Write a query to compare product usage data with billing records.
For example, compare the number of active users of a product with the billed amount.*/

SELECT 
       P.product_id,
	   P.usage_month,
	   P.active_users,
	   P.included_users,
GREATEST(P.active_users-P.included_users,0) AS Additional_users,
		B.billed_amount,
	    B.expected_amount,
	    B.expected_amount-B.billed_amount AS Underbilled_amount,
	    B.bill_date, 
	    B.payment_status
FROM Product_Usage P
JOIN Billing B
ON P.product_id= B.product_id
AND P.customer_id= B.customer_id

-- Identify any discrepancies where customers have used
-- more of a product than they have been billed for.

SELECT
    P.customer_id,
    P.product_id,
    P.usage_month,
    P.active_users,
    P.included_users,
    P.active_users - P.included_users AS additional_users,
    B.expected_amount,
    B.billed_amount,
    B.expected_amount - B.billed_amount AS underbilled_amount
FROM Product_Usage P
JOIN Billing B
    ON P.customer_id = B.customer_id
    AND P.product_id = B.product_id
WHERE P.active_users > P.included_users
  AND B.expected_amount > B.billed_amount;
```


### Key Findings
The analysis identified 5 customers whose recorded active users exceeded the number of users included in their plans.

<img width="703" height="368" alt="image" src="https://github.com/user-attachments/assets/30c4cd2c-29ee-499b-a159-b6ef4977b783" />


One accuracy point: this analysis identifies **usage discrepancies**, not a monetary leakage amount by itself. The actual financial impact would require a rule for charging those additional users.

---

### 4. Overdue Payment Analysis

```
### 4. Overdue Payment Analysis

**Business Question**

Which customers have unpaid or overdue invoices, and what is the value of the outstanding payments?

**Analysis Logic**

An invoice is considered overdue when the payment has not been recorded and the due date has passed.

```text
Payment Date IS NULL
AND Due Date < Current Date
```

The analysis identifies unpaid invoices that have passed their due dates and reports the associated invoice amounts.

```-- Write a query to identify customers who have missed payments or have overdue invoices.

SELECT
   customer_id,
    billed_amount,
    due_date,
    payment_date,
    payment_status
FROM Billing
WHERE payment_status = 'Overdue'
   OR (
        due_date < GETDATE()
        AND payment_date IS NULL
      )
	 
-- Provide details of customers with outstanding invoices,
-- including the invoice amount and the date the payment was due.

SELECT 
    customer_id,
    billing_id AS Invoice_id,
    billed_amount AS Invoice_amount,
    due_date,
    payment_status
FROM Billing
WHERE payment_date IS NULL;
```

### Key Finding

The analysis identified 3 customers with overdue invoices, representing £1,200.00 in potential missed-payment exposure.

<img width="683" height="354" alt="image" src="https://github.com/user-attachments/assets/35f29e32-fd73-44db-a94a-b9c1be9431c0" />


---



### 5. Executive Revenue Leakage Summary

**Business Question**

What is the total potential revenue leakage across under-billing, excessive discounts, and missed payments during the June–August 2026 review period?

**Analysis Logic**

The final query consolidates the three financial leakage categories into a single executive-level summary:

- Under-billing
- Excessive discounts
- Missed payments

It also identifies the number of unique customers with at least one potential revenue leakage issue.

**Result**

| Revenue Leakage Category | Potential Leakage |
|---|---:|
| Under-billing | £710.00 |
| Excessive Discounts | £214.00 |
| Missed Payments | £1,200.00 |
| **Total Potential Revenue Leakage** | **£2,124.00** |

### Customers with Potential Revenue Leakage

**7 unique customers** were identified with at least one potential revenue leakage issue during the review period.

<img width="932" height="445" alt="image" src="https://github.com/user-attachments/assets/4298c1ad-4a56-4b5b-865c-2a9d28a9440c" />

**Key Finding**

The analysis identified **£2,124.00 in potential revenue leakage** across the three financial leakage categories.

Missed payments represented the largest component at **£1,200.00**, followed by under-billing at **£710.00** and excessive discounts at **£214.00**.

```sql
/* EXECUTIVE REVENUE LEAKAGE SUMMARY
   Review Period: June 2026 - August 2026  */

WITH UnderBilling AS
(
    SELECT
        SUM(B.expected_amount - B.billed_amount) AS Amount
    FROM Billing AS B
    WHERE B.expected_amount > B.billed_amount
      AND B.bill_date BETWEEN '2026-06-01' AND '2026-08-31'
),

ExcessiveDiscounts AS
(
    SELECT
        SUM(
            CASE
                WHEN D.discount_percentage > P.max_discount_pct
                THEN D.discount_amount
                     * (D.discount_percentage - P.max_discount_pct)
                     / NULLIF(D.discount_percentage, 0)
                ELSE 0
            END
        ) AS Amount
    FROM Discounts AS D
    INNER JOIN Products AS P
        ON D.product_id = P.product_id
    WHERE D.discount_date BETWEEN '2026-06-01' AND '2026-08-31'
),

MissedPayments AS
(
    SELECT
        SUM(B.billed_amount) AS Amount
    FROM Billing AS B
    WHERE B.payment_date IS NULL
      AND B.due_date < GETDATE()
      AND B.bill_date BETWEEN '2026-06-01' AND '2026-08-31'
),

AffectedCustomers AS
(
    SELECT B.customer_id
    FROM Billing AS B
    WHERE B.expected_amount > B.billed_amount
      AND B.bill_date BETWEEN '2026-06-01' AND '2026-08-31'

    UNION

    SELECT D.customer_id
    FROM Discounts AS D
    INNER JOIN Products AS P
        ON D.product_id = P.product_id
    WHERE D.discount_percentage > P.max_discount_pct
      AND D.discount_date BETWEEN '2026-06-01' AND '2026-08-31'

    UNION

    SELECT B.customer_id
    FROM Billing AS B
    WHERE B.payment_date IS NULL
      AND B.due_date < GETDATE()
      AND B.bill_date BETWEEN '2026-06-01' AND '2026-08-31'
)

SELECT
    'Under-billing' AS Report_Metric,
    UB.Amount AS Value
FROM UnderBilling AS UB

UNION ALL

SELECT
    'Excessive Discounts',
    ED.Amount
FROM ExcessiveDiscounts AS ED

UNION ALL

SELECT
    'Missed Payments',
    MP.Amount
FROM MissedPayments AS MP

UNION ALL

SELECT
    'Total Potential Revenue Leakage',
    UB.Amount + ED.Amount + MP.Amount
FROM UnderBilling AS UB
CROSS JOIN ExcessiveDiscounts AS ED
CROSS JOIN MissedPayments AS MP

UNION ALL

SELECT
    'Customers Affected',
    CAST(COUNT(*) AS VARCHAR(20))
FROM AffectedCustomers;
```
<img width="707" height="382" alt="image" src="https://github.com/user-attachments/assets/0b71151f-a5d6-4e1b-aa67-2486331cd644" />



## Business Impact

The analysis demonstrates how SQL can be used as a revenue assurance tool to identify potential areas of financial exposure within a SaaS business.

The findings highlight three key areas requiring attention:

- **Under-billing:** £710.00 in potential under-billing was identified across four customers, indicating that billing records should be monitored against expected charges.
- **Excessive discounts:** £214.00 in potential leakage was associated with discounts exceeding the defined product-level thresholds, highlighting the importance of discount controls.
- **Missed payments:** £1,200.00 in unpaid or overdue invoices was identified across three customers, representing the largest component of the potential leakage.

Overall, the analysis identified **£2,124.00 in potential revenue leakage across 7 unique customers** during the review period.

From a business perspective, the analysis shows how structured SQL checks can help organisations:

- Detect billing discrepancies before they become recurring issues
- Monitor discounts against approved pricing rules
- Identify customers with outstanding payment obligations
- Prioritise areas of potential revenue exposure for further investigation
- Strengthen financial and revenue assurance processes

> **Portfolio context:** The figures above are based on the sample dataset created for this project and demonstrate the type of business insight that can be generated from a structured revenue leakage analysis.








