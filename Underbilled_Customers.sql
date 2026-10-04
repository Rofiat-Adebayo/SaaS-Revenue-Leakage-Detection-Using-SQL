/* Detect under-billed customers
identifying customers whose billed amount is consistently lower than their subscription plan cost.*/

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


/* Provide a report of customers who have been undercharged 
for their subscriptions or products for the past 3 months.*/

SELECT
    B.customer_id,
    COUNT(*) AS Undercharged_Billtimes,
    SUM(S.contracted_price - B.billed_amount) AS Total_Undercharged
FROM Billing B
INNER JOIN Subscriptions S
    ON B.subscription_id = S.subscription_id
WHERE B.billed_amount < S.contracted_price
  AND B.bill_date > DATEADD(MONTH, -3, GETDATE())
GROUP BY B.customer_id
ORDER BY Total_Undercharged DESC;
