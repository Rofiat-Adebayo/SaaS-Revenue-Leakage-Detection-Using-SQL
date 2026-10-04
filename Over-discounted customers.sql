/*Write a query to find customers who have received discounts
above a certain threshold ( more than 20% off).*/

SELECT customer_id,
		discount_percentage,
		discount_date,
		discount_status
FROM Discounts
WHERE discount_percentage >20.00
ORDER BY discount_percentage DESC


/*Provide a report showing the customers 
who have received excessive discounts, including
details of the discount percentage and total discount applied.*/

SELECT
	  customer_id,
		D.discount_percentage,
		P.standard_price* d.discount_percentage/100 AS Total_discount_applied,
		D.discount_percentage -P.max_discount_pct AS Excessive_Discount_pct
FROM Discounts D
JOIN Products P
ON D.product_id= P.product_id
WHERE discount_percentage>p.max_discount_pct


SELECT *FROM Products

