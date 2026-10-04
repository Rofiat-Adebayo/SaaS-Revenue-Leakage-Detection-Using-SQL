-- Write a query to identify customers who have missed payments or have overdue invoices.

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



	