/*Write a query to compare product usage data with billing records.
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






