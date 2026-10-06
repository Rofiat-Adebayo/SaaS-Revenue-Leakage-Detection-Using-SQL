# SaaS-Revenue-Leakage-Detection
A SQL-based revenue assurance project designed to identify potential revenue leakage in a SaaS business by analysing under-billing, excessive discounts, product usage discrepancies, and overdue payments.

## Table of Contents

- [Executive Summary](#executive-summary)
- [Key Results](#key-results)
- [Business Problem](#business-problem)
- [Business Questions](#business-questions)
- [Review Period & Assumptions](#review-period--assumptions)
- [Data Model](#data-model)
- [Data Dictionary](#data-dictionary)
- [Data Quality Checks](#data-quality-checks)
- [Database Creation](#database-creation)
- [SQL Analysis](#sql-analysis)
  - [Under-billing Analysis](#1-under-billing-analysis)
  - [Excessive Discount Analysis](#2-excessive-discount-analysis)
  - [Usage and Billing Discrepancy Analysis](#3-usage-and-billing-discrepancy-analysis)
  - [Late and Overdue Payment Analysis](#4-late-and-overdue-payment-analysis)
  - [Executive Revenue Leakage Summary](#5-executive-revenue-leakage-summary)
- [Business Impact](#business-impact)
- [Recommendations](#recommendations)
- [Technical Skills Demonstrated](#technical-skills-demonstrated)
- [Project Structure](#project-structure)
- [How to Run the Project](#how-to-run-the-project)
- [Conclusion](#conclusion)




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

<img width="2476" height="1111" alt="Untitled" src="https://github.com/user-attachments/assets/e89e68ff-2b12-4489-96cf-47d5cbf43af9" />




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

[View Data quality check script](https://github.com/Rofiat-Adebayo/SaaS-Revenue-Leakage-Detection-Using-SQL/blob/main/Data%20quality%20check.sql)




## Database Creation

A relational SQL Server database was created from scratch to support the
revenue leakage analysis. The database consists of six interconnected tables:

- `Customers`
- `Products`
- `Subscriptions`
- `Billing`
- `Discounts`
- `Product_Usage`

The script also includes the sample data used throughout the analysis.



[View Database Creation & Sample Data SQL](https://github.com/Rofiat-Adebayo/SaaS-Revenue-Leakage-Detection-Using-SQL/blob/main/Database%20Creation.sql)




## SQL Analysis

The SQL analysis translates the business questions into measurable revenue leakage indicators using SQL Server. Each analysis focuses on a specific leakage area and produces a result that can be reviewed independently before being consolidated into the final revenue leakage summary.




### 1. Under-billing Analysis

**Business Question**

Which customers were under-billed during the June–August 2026 review period, and what was the potential under-billed amount?

**Analysis Logic**

A billing record is considered under-billed when the `billed_amount` is less than the `expected_amount`.

```
Potential Under-billing = Expected Amount - Billed Amount
```

  
<details>
<summary><strong>Click to View the SQL Query</strong></summary>

```sql
/* Detect under-billed customers
   Identifying customers whose billed amount is consistently
   lower than their subscription plan cost. */

SELECT
    B.customer_id,
    COUNT(*) AS Total_Bills,
    SUM(
        CASE
            WHEN B.billed_amount < S.contracted_price THEN 1
            ELSE 0
        END
    ) AS Underbilled_Times
FROM Billing AS B
INNER JOIN Subscriptions AS S
    ON B.subscription_id = S.subscription_id
GROUP BY B.customer_id
HAVING COUNT(*) =
       SUM(
           CASE
               WHEN B.billed_amount < S.contracted_price THEN 1
               ELSE 0
           END
       );
```

</details>



**Result Analysis**

The analysis identified **3 customers (102, 104, and 108)** who were under-billed on **all 3 billing records** analysed. This indicates a recurring under-billing pattern rather than a one-off billing discrepancy.

Customer 106 was excluded because only **1 of its 3 billing records** was under-billed, meaning the issue was not consistent across the review period.

<img width="692" height="386" alt="image" src="https://github.com/user-attachments/assets/d1188a08-77d3-4657-ab60-a2a961ef7ec4" />


**Key Finding:** Customers 102, 104, and 108 show a consistent under-billing pattern across all three billing records, making them priority customers for further billing review.



### Under-billing Report: Customers with Undercharged Bills 

**Business Question 2:**


Which customers were undercharged for their subscriptions or products during the June–August 2026 review period, and what was the total potential undercharged amount?

**Analysis Logic**

A billing record is considered undercharged when the customer's `billed_amount` is lower than their `contracted_price`.

The query counts the number of undercharged billing records for each customer and calculates the total potential undercharged amount.

```Calculation
Potential Under-billing = Contracted Price - Billed Amount
```

<details>
<summary><strong>Click to View SQL Query</strong></summary>

```sql
/* Provide a report of customers who have been undercharged
   for their subscriptions or products for the June–August 2026 review period. */

SELECT
    B.customer_id,
    COUNT(*) AS Undercharged_Billtimes,
    SUM(S.contracted_price - B.billed_amount) AS Total_Undercharged
FROM Billing AS B
INNER JOIN Subscriptions AS S
    ON B.subscription_id = S.subscription_id
WHERE B.billed_amount < S.contracted_price
  AND B.bill_date BETWEEN '2026-06-01' AND '2026-08-31'
GROUP BY B.customer_id;
```
</details>



### Result Analysis

The analysis identified **4 customers** with potential under-billing during the June–August 2026 review period.

- **Customer 104** had the highest potential under-billing, with **3 undercharged bills** totalling **£450.00**.
- **Customer 102** had **3 undercharged bills**, resulting in **£150.00** in potential under-billing.
- **Customer 108** had **3 undercharged bills**, resulting in **£90.00** in potential under-billing.
- **Customer 106** had **1 undercharged bill**, resulting in **£20.00** in potential under-billing.

Overall, **10 undercharged billing records** were identified, representing **£710.00 in potential under-billing**.

The results show that customers 102, 104, and 108 experienced under-billing across all three months, indicating a recurring billing discrepancy, while customer 106 experienced a one-off under-billing event.

<img width="678" height="334" alt="image" src="https://github.com/user-attachments/assets/9d595081-212d-4620-a7e3-bbd80b1240cc" />

### Key Findings

- **4 customers** were identified with potential under-billing during the June–August 2026 review period.
- **10 undercharged billing records** were identified, representing **£710.00 in potential under-billing**.
- Customers **102, 104, and 108** were under-billed across all three months, indicating a recurring under-billing pattern.
- **Customer 104** had the highest potential under-billing at **£450.00**.
- **Customer 106** experienced a one-off under-billing issue of **£20.00**.


---

### 2. Excessive Discount Analysis

**Business Question 1**

Which customers received discounts above the maximum discount threshold permitted for their products?

**Analysis Logic**

A discount is considered excessive when:

```
Discount Percentage > Maximum Allowed Discount Percentage
```




<details>
 <summary><strong>Click to View SQL Query</strong></summary>

```sql
/* Find customers who have received discounts
   above the 20% threshold. */

SELECT
    customer_id,
    discount_percentage,
    discount_date,
    discount_status
FROM Discounts
WHERE discount_percentage > 20.00
ORDER BY discount_percentage DESC;
```
</details>




### Result Analysis
The query identified 4 customers who received discounts above the defined 20% threshold. Customer 107 received the highest discount at 35%, followed by customer 104 at 30%, customer 105 at 25%, and customer 109 at 22%.

<img width="703" height="389" alt="image" src="https://github.com/user-attachments/assets/7c390f82-1646-4f71-9cec-8fd8eedf300f" />


### Key Finding

The analysis identified 4 customers with discounts above the permitted product-level threshold, representing £214.00 in potential excessive discount leakage.



### Business Question 2**

Which customers received excessive discounts, and how much discount was applied above the maximum threshold allowed for their products?

**Analysis Logic**

A discount is considered excessive when the customer's `discount_percentage` exceeds the product's `max_discount_pct`.

**Calculations:**

- `Total Discount Applied = Standard Price × Discount Percentage / 100`
- `Excessive Discount % = Discount Percentage - Maximum Allowed Discount %`




<details>
<summary><strong>Click to View the SQL Query</strong></summary>

```sql
/* Provide a report showing customers
   who have received excessive discounts, including
   details of the discount percentage and total discount applied. */

SELECT
    D.customer_id,
    D.discount_percentage,
    P.standard_price * D.discount_percentage / 100 AS Total_discount_applied,
    D.discount_percentage - P.max_discount_pct AS Excessive_Discount_pct
FROM Discounts AS D
INNER JOIN Products AS P
    ON D.product_id = P.product_id
WHERE D.discount_percentage > P.max_discount_pct
ORDER BY Excessive_Discount_pct DESC;
```

</details>




### Result Analysis

The query identified **4 customers** who received discounts above their product-level maximum allowed discount.

Customer **107** received the largest excessive discount at **15 percentage points above the permitted threshold**, while customer **109** had the smallest excess at **2 percentage points**.

The total discount applied based on standard product prices ranged from **£44.00 to £280.00** across the four customers.

<img width="638" height="416" alt="image" src="https://github.com/user-attachments/assets/afb0c331-5d90-439b-948c-5d73de9b2837" />

### Key Finding

- **4 customers** received discounts above the permitted threshold.
- Customer **107** had the highest excessive discount at **15 percentage points above the limit**.
- Customer **104** followed with an excess of **10 percentage points**.
- The analysis highlights customers whose discounts may require closer review against the defined pricing rules.
---



### 3. Usage and Billing Discrepancy Analysis

**Business Question**

How does customer product usage compare with their billing records?

**Analysis Logic**

The analysis combines product usage and billing records for the same customer and product to compare usage levels with billing information.

The analysis examines:

- `active_users` against `included_users` to identify usage above the customer's plan allowance.
- `expected_amount` against `billed_amount` to identify billing differences.
- `additional_users` to show how far usage exceeds the included allowance.
- `underbilled_amount` to quantify any difference between the expected and billed amounts.




 <details>
<summary><strong>Click to View the SQL Query</strong></summary>

```sql
/* Write a query to compare product usage data with billing records.
   For example, compare the number of active users of a product
   with the billed amount. */

SELECT
    P.customer_id,
    P.product_id,
    P.usage_month,
    P.active_users,
    P.included_users,
    GREATEST(P.active_users - P.included_users, 0) AS Additional_users,
    B.billed_amount,
    B.expected_amount,
    B.expected_amount - B.billed_amount AS Underbilled_amount,
    B.bill_date,
    B.payment_status
FROM Product_Usage AS P
INNER JOIN Billing AS B
    ON P.customer_id = B.customer_id
   AND P.product_id = B.product_id
   AND YEAR(P.usage_month) = YEAR(B.bill_date)
   AND MONTH(P.usage_month) = MONTH(B.bill_date);
```

</details>





### Result Analysis

The analysis provides a side-by-side view of customer product usage and billing information for the same billing period.

The results show that some customers were using more users than their plans included, while others were billed at their expected amounts. The comparison also highlights customers where usage and billing discrepancies occur at the same time.

For example, customer **102** recorded **68 active users** against **50 included users** and was billed **£300** against an expected **£350**, resulting in **£50 of potential under-billing**.

Customer **104** recorded **245 active users** against **200 included users** and was billed **£650** against an expected **£800**, resulting in **£150 of potential under-billing**.

Customer **107** recorded **270 active users** against **200 included users**, but was billed the full expected amount of **£800**, showing that higher usage does not automatically result in a billing discrepancy.


<img width="686" height="335" alt="image" src="https://github.com/user-attachments/assets/59b6c3dd-b411-4a9c-86af-816001344cb6" />


### Key Findings

- The analysis identified customers where **usage exceeded their included allowance**.
- It also identified cases where **higher usage occurred alongside under-billing**.
- Customers **102 and 104** showed both a usage discrepancy and a billing discrepancy.
- Customer **107** exceeded the included usage allowance but had **no billing shortfall**, demonstrating that usage and billing discrepancies do not always occur together.
- The analysis demonstrates how combining usage and billing data can help identify potential areas for further revenue review.

### 2.Usage and Billing Discrepancy Analysis

**Business Question**

Which customers have used more of a product than they have been billed for?

**Analysis Logic**

A customer is identified as having a usage and billing discrepancy when both conditions are met:

- `Active Users > Included Users`
- `Expected Amount > Billed Amount`

**Calculations:**

- `Additional Users = Active Users - Included Users`
- `Under-billed Amount = Expected Amount - Billed Amount`





<details>
<summary><strong>Click to View the SQL Query</strong></summary>

```sql
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
FROM Product_Usage AS P
INNER JOIN Billing AS B
    ON P.customer_id = B.customer_id
    AND P.product_id = B.product_id
    AND YEAR(P.usage_month) = YEAR(B.bill_date)
    AND MONTH(P.usage_month) = MONTH(B.bill_date)
WHERE P.active_users > P.included_users
  AND B.expected_amount > B.billed_amount;
```

</details>





### Result Analysis

The analysis identified **2 customers** whose product usage exceeded their included allowance while their billed amount was below the expected amount.

- **Customer 102** recorded **18 additional users** and **£50.00** in potential under-billing.
- **Customer 104** recorded **45 additional users** and **£150.00** in potential under-billing.

Together, the two customers recorded **63 additional users** above their included allowances and **£200.00 in potential under-billing**.

<img width="677" height="382" alt="image" src="https://github.com/user-attachments/assets/33884336-17eb-4e80-99cc-ff3419b71a3d" />


### Key Findings

- **2 customers** were identified with both a usage discrepancy and a billing shortfall.
- Customer **104** had the largest discrepancy, with **45 additional users** and **£150.00** in potential under-billing.
- Customer **102** had **18 additional users** and **£50.00** in potential under-billing.
- The analysis demonstrates that combining usage and billing data can identify customers where increased usage coincides with a potential billing shortfall.
---


### 4. Late and Overdue Payment Analysis

**Business Question**

Which customers have missed payments or have overdue invoices?

**Analysis Logic**

An invoice is identified as a potential missed or overdue payment when either:

- `payment_status = 'Overdue'`, or
- the `due_date` has passed and `payment_date` is `NULL`.

This allows the analysis to identify unpaid invoices using both the recorded payment status and the underlying payment dates.





<details>
<summary><strong>Click to View the SQL Query</strong></summary>

```sql
-- Write a query to identify customers who have missed payments
-- or have overdue invoices.

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
      );
```

</details>





### Result Analysis

The analysis identified **3 customers** with overdue invoices and no recorded payment.

- **Customer 105** has an overdue invoice of **£200.00**.
- **Customer 107** has an overdue invoice of **£800.00**, representing the largest outstanding amount.
- **Customer 109** has an overdue invoice of **£200.00**.

The combined value of the identified overdue invoices is **£1,200.00**.

<img width="637" height="350" alt="image" src="https://github.com/user-attachments/assets/15b8fb34-27d6-448b-b89f-105e5df4176c" />


### Key Findings

- **3 customers** were identified with overdue or missed payments.
- The total value of the identified overdue invoices is **£1,200.00**.
- **Customer 107** has the largest overdue invoice at **£800.00**.
- All three invoices have a `NULL` payment date, indicating that no payment has been recorded for these invoices.
---



### Business Question 2**

Which customers have outstanding invoices, and what are the invoice amounts and payment due dates?

**Analysis Logic**

An invoice is considered outstanding when no payment has been recorded.

This is identified using:

**`payment_date IS NULL`**

The query returns the customer, invoice ID, invoice amount, due date, and current payment status.




<details>
<summary><strong>Click to View the SQL Query</strong></summary>

```sql
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

</details>





### Result Analysis

The query identified **3 outstanding invoices** with no recorded payment.

- **Customer 105** has an outstanding invoice of **£200.00**, due on **15 August 2026**.
- **Customer 107** has an outstanding invoice of **£800.00**, due on **15 August 2026**.
- **Customer 109** has an outstanding invoice of **£200.00**, due on **15 August 2026**.

The combined value of the outstanding invoices is **£1,200.00**.

All three outstanding invoices are marked as **Overdue** in the sample data.


<img width="689" height="395" alt="image" src="https://github.com/user-attachments/assets/2ca19970-65b0-4841-adbe-9be86c64ac22" />

### Key Findings

- **3 outstanding invoices** were identified.
- The total outstanding amount is **£1,200.00**.
- Customer **107** has the largest outstanding invoice at **£800.00**.
- All identified outstanding invoices have passed their payment due date and are marked as overdue.




### 5. Executive Revenue Leakage Summary

**Business Question**

What is the total potential revenue leakage from under-billing, excessive discounts, and missed payments, and how many unique customers have at least one potential revenue leakage issue?

**Analysis Logic**

The final query consolidates the three main financial leakage categories identified in the analysis:

- **Under-billing:** `Expected Amount - Billed Amount`
- **Excessive Discounts:** The portion of a discount that exceeds the product's maximum permitted discount
- **Missed Payments:** Unpaid invoices where the due date has passed
- **Customers with Potential Revenue Leakage:** Unique customers identified across all three categories

The `UNION` operation is used to combine customers from the three leakage categories while removing duplicates, ensuring that each customer is counted only once.





<details>
<summary><strong>Click to View the SQL Query</strong></summary>

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

</details>





### Result Analysis

The final analysis identified **£2,124.00 in potential revenue leakage** across the June–August 2026 review period.

- **Under-billing:** £710.00
- **Excessive discounts:** £214.00
- **Missed payments:** £1,200.00

A total of **7 unique customers** were identified with at least one potential revenue leakage issue across the three categories.

<img width="693" height="383" alt="image" src="https://github.com/user-attachments/assets/e626a3b6-c14f-4d8b-a7a9-193cdf18baba" />



### Key Findings

- **£2,124.00** in total potential revenue leakage was identified.
- **Missed payments** represented the largest component at **£1,200.00**, accounting for approximately **56.5%** of the total.
- **Under-billing** accounted for **£710.00**, or approximately **33.4%** of the total.
- **Excessive discounts** accounted for **£214.00**, or approximately **10.1%** of the total.
- **7 unique customers** had at least one potential revenue leakage issue.
- Missed payments and under-billing were the two largest sources of identified financial exposure in the sample data.



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

> **Portfolio context:** The figures are based on the sample dataset created for this project and demonstrate how structured SQL analysis can be used to identify potential revenue leakage and generate actionable business insights.



## Recommendations

Based on the revenue leakage findings, the following actions could help reduce potential leakage:

1. **Strengthen billing controls**  
   Introduce automated checks that compare expected charges with actual billed amounts to identify under-billing before invoices are finalised.

2. **Implement discount controls**  
   Require approval for discounts that exceed the maximum threshold defined for each product.

3. **Monitor customer usage**  
   Regularly compare actual product usage with included subscription allowances to identify customers whose usage may require plan or billing review.

4. **Improve overdue payment monitoring**  
   Implement automated alerts for invoices approaching or passing their due dates to support timely payment collection.

5. **Prioritise high-value leakage cases**  
   Focus investigation and corrective action on the customers and leakage categories with the largest potential financial exposure.



## Technical Skills Demonstrated

This project demonstrates the following technical, database, and analytical skills:

### Database Development

- SQL Server database creation
- Relational database design
- Schema design and table creation
- Primary and foreign key implementation
- One-to-many table relationships
- Data types and column design
- `CREATE TABLE` statements
- `INSERT` statements for sample data generation
- `CHECK` and `UNIQUE` constraints
- Referential integrity

### SQL & Data Analysis

- `INNER JOIN` and multi-table joins
- `GROUP BY` and `HAVING`
- Aggregate functions such as `SUM()` and `COUNT()`
- `COUNT(DISTINCT)`
- `CASE` expressions
- `UNION` and `UNION ALL`
- Common Table Expressions (CTEs)
- Date filtering and date functions
- Conditional logic and business rules
- Revenue leakage calculations

### Data Quality & Validation

- Duplicate record detection
- Referential integrity checks
- Financial value validation
- Discount percentage validation
- Date consistency checks
- Data quality assessment before analysis

### Business & Analytical Skills

- Revenue leakage analysis
- Revenue assurance
- Billing discrepancy analysis
- Discount control analysis
- Customer usage analysis
- Payment and overdue invoice analysis
- Translating business questions into SQL logic
- Quantifying potential financial exposure
- Converting SQL results into actionable business insights




## Project Structure

```
saas-revenue-leakage/
│
├── README.md
│
├── database/
│   ├── 01_create_tables.sql
│   ├── 02_insert_sample_data.sql
│   └── 03_data_quality_checks.sql
│
├── sql/
│   ├── 01_underbilling.sql
│   ├── 02_excessive_discounts.sql
│   ├── 03_usage_vs_billing.sql
│   ├── 04_overdue_invoices.sql
│   └── 05_revenue_leakage_summary.sql
│
└── docs/
    └── data_dictionary.md
```


## How to Run the Project

### 1. Create the Database and Load Sample Data

Run the database setup script. It creates the tables, relationships,
constraints, and inserts the sample data.

[View Database Creation & Sample Data SQL](https://github.com/Rofiat-Adebayo/SaaS-Revenue-Leakage-Detection-Using-SQL/blob/main/Database%20Creation.sql)


### 2. Run Data Quality Checks

[View Data Quality Checks SQL](https://github.com/Rofiat-Adebayo/SaaS-Revenue-Leakage-Detection-Using-SQL/blob/main/Data%20quality%20check.sql)


### 3. Run the Analysis Queries

- [Under-billing](https://github.com/Rofiat-Adebayo/SaaS-Revenue-Leakage-Detection-Using-SQL/blob/main/Underbilled_Customers.sql)
- [Excessive Discounts](https://github.com/Rofiat-Adebayo/SaaS-Revenue-Leakage-Detection-Using-SQL/blob/main/Over-discounted%20customers.sql)
- [Usage and Billing Discrepancy](https://github.com/Rofiat-Adebayo/SaaS-Revenue-Leakage-Detection-Using-SQL/blob/main/Product%20usage%20vs%20billing.sql)
- [Overdue Payments](https://github.com/Rofiat-Adebayo/SaaS-Revenue-Leakage-Detection-Using-SQL/blob/main/Late%20payment%20detection.sql)
- [Revenue Leakage Summary](https://github.com/Rofiat-Adebayo/SaaS-Revenue-Leakage-Detection-Using-SQL/blob/main/Revenue%20leekage%20report.sql)




## Conclusion

This project demonstrates how SQL can be used to investigate potential revenue leakage within a SaaS business by combining customer, subscription, billing, discount, product usage, and payment data.

The analysis identified **£2,124.00 in potential revenue leakage** across under-billing, excessive discounts, and missed payments, with **7 unique customers** having at least one potential leakage issue during the review period.

Beyond identifying individual discrepancies, the project demonstrates an end-to-end SQL workflow covering:

- Database and relational schema design
- Sample data creation
- Data quality validation
- Business-focused SQL analysis
- Revenue leakage quantification
- Translating SQL results into actionable business insights

Overall, the project demonstrates how structured SQL analysis can support **revenue assurance, financial control, and data-driven decision-making**.



