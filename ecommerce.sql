Create database ECOMMERCE

use ECOMMERCE


select * from cleanedData

EXEC SP_RENAME 'cleanedData.[State/Province]','state','column'
EXEC SP_RENAME 'cleanedData.[Country/Region]','country','column'


-------------- Total Revenue  -------------------------

SELECT round(SUM(sales),2) AS total_revenue FROM CleanedData


--------------- Monthly Revenue ------------------------

SELECT 
    FORMAT([Order Date], 'yyyy-MM') AS month,
    SUM(sales) AS revenue
FROM CleanedData
GROUP BY FORMAT([order Date], 'yyyy-MM')
ORDER BY month;

------------ Top Customers ------------------------------

SELECT 
    [Customer Name],
    SUM(sales) AS total_spent
FROM cleanedData
GROUP BY [Customer Name]
ORDER BY total_spent DESC

------------ Repeat Customers ------------------------------

SELECT 
    [Customer ID],
    COUNT([Order ID]) AS orders_count
FROM cleanedData
GROUP BY [Customer ID]
HAVING COUNT([Order ID]) > 1


------------- Top Products ---------------------------------

SELECT 
    [Product Name],
    SUM(sales) AS revenue
FROM cleanedData
GROUP BY [Product Name]
ORDER BY revenue DESC


----------- Region-wise Sales ------------------------

SELECT 
    region,
    round(SUM(sales),2) AS revenue
FROM cleanedData
GROUP BY region

------------ Profit Analysis ----------------------------

SELECT 
    Category,
    round(SUM(profit),2) AS total_profit
FROM cleanedData
GROUP BY Category

go


------------ Top 5 Products per Category ------------------------


WITH ranked_products AS (
    SELECT 
        category,
        [Product Name],
        SUM(sales) AS revenue,
        RANK() OVER (PARTITION BY category ORDER BY SUM(sales) DESC) AS rnk
    FROM cleanedData
    GROUP BY category, [Product Name]
)
SELECT * 
FROM ranked_products
WHERE rnk <= 5;