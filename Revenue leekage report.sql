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

