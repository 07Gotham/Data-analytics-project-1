USE customer_behavior;

-- 1. Total revenue by gender
SELECT 
    Gender, 
    SUM(Purchase_Amount_USD) AS revenue
FROM customer
GROUP BY Gender;

-- 2. Customers who used discount AND spent above average
SELECT 
    Customer_ID, 
    Purchase_Amount_USD
FROM customer
WHERE Discount_Applied = 'Yes'
AND Purchase_Amount_USD >= (
    SELECT AVG(Purchase_Amount_USD)
    FROM customer
);

-- 3. Top 5 products by average review rating
SELECT 
    Item_Purchased,
    ROUND(AVG(Review_Rating), 2) AS average_product_rating
FROM customer
GROUP BY Item_Purchased
ORDER BY average_product_rating DESC
LIMIT 5;

-- 4. Average purchase: Standard vs Express shipping
SELECT 
    Shipping_Type, 
    ROUND(AVG(Purchase_Amount_USD), 2) AS avg_purchase
FROM customer
WHERE Shipping_Type IN ('Standard', 'Express')
GROUP BY Shipping_Type;

-- 5. Subscribers vs Non-subscribers spending
SELECT 
    Subscription_Status,
    COUNT(Customer_ID) AS total_customers,
    ROUND(AVG(Purchase_Amount_USD), 2) AS avg_spend,
    ROUND(SUM(Purchase_Amount_USD), 2) AS total_revenue
FROM customer
GROUP BY Subscription_Status
ORDER BY total_revenue DESC, avg_spend DESC;

-- 6. Top 5 products with highest discount usage %
SELECT 
    Item_Purchased,
    ROUND(
        SUM(CASE WHEN Discount_Applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS discount_rate
FROM customer
GROUP BY Item_Purchased
ORDER BY discount_rate DESC
LIMIT 5;

-- 7. Customer segmentation
WITH customer_type AS (
    SELECT 
        Customer_ID,
        Previous_Purchases,
        CASE 
            WHEN Previous_Purchases = 1 THEN 'New'
            WHEN Previous_Purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer
)
SELECT 
    customer