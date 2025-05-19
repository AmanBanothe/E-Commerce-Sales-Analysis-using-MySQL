#Analytical Queries/ Questions

#1.Total Revenue
SELECT ROUND(SUM(Quantity * UnitPrice), 2) AS Total_Revenue
FROM online_retail
WHERE Quantity > 0;

# 2. Top 10 Selling Products
SELECT Description, SUM(Quantity) AS Total_Sold
FROM online_retail
WHERE Quantity > 0
GROUP BY Description
ORDER BY Total_Sold DESC
LIMIT 10;

#3. Monthly Sales Trend
SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month, ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Month
ORDER BY Month;

#4. Country-wise Revenue
SELECT Country, ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Country
ORDER BY Revenue DESC;

#5. Repeat vs New Customers
SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM online_retail
WHERE CustomerID IS NOT NULL;

#6 Cancelled Orders Count & Revenue Loss
SELECT COUNT(DISTINCT InvoiceNo) AS Cancelled_Orders,
ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue_Lost
FROM online_retail
WHERE InvoiceNo LIKE 'C%';

#7 Most Returned Products (Negative Quantity)
SELECT Description, ABS(SUM(Quantity)) AS Total_Returned
FROM online_retail
WHERE Quantity < 0
GROUP BY Description
ORDER BY Total_Returned DESC
LIMIT 10;

#8 Top 10 Revenue-Generating Products
SELECT Description, ROUND(SUM(Quantity * UnitPrice), 2) AS Total_Revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Description
ORDER BY Total_Revenue DESC
LIMIT 10;

#9 Average Basket Size (items per invoice)
SELECT ROUND(AVG(items_per_invoice), 2) AS Avg_Basket_Size
FROM ( SELECT InvoiceNo, SUM(Quantity) AS items_per_invoice
FROM online_retail
WHERE Quantity > 0
GROUP BY InvoiceNo
) AS sub;

#10 Average Order Value (AOV)
SELECT ROUND(AVG(order_value), 2) AS Avg_Order_Value
FROM (
SELECT InvoiceNo, SUM(Quantity * UnitPrice) AS order_value
FROM online_retail
WHERE Quantity > 0
GROUP BY InvoiceNo
) AS sub;

#11 Customer Lifetime Revenue (Top Customers)
SELECT CustomerID, ROUND(SUM(Quantity * UnitPrice), 2) AS Lifetime_Value
FROM online_retail
WHERE Quantity > 0 AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Lifetime_Value DESC
LIMIT 10;

#12 Monthly Active Customers
SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
COUNT(DISTINCT CustomerID) AS Active_Customers
FROM online_retail
WHERE CustomerID IS NOT NULL
GROUP BY Month
ORDER BY Month;

#12 Revenue Contribution by Top 5 Countries
SELECT Country, ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 5;

#13 Invoices with High Value (≥ ₹10,000)
SELECT InvoiceNo, ROUND(SUM(Quantity * UnitPrice), 2) AS Invoice_Value
FROM online_retail
WHERE Quantity > 0
GROUP BY InvoiceNo
HAVING Invoice_Value >= 10000
ORDER BY Invoice_Value DESC;

#14 Unique Products Sold
SELECT COUNT(DISTINCT StockCode) AS Unique_Products_Sold
FROM online_retail
WHERE Quantity > 0;

#15 Top 5 Customers per Country (Window Function)
SELECT *
FROM (
SELECT CustomerID, Country,
ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue,
RANK() OVER (PARTITION BY Country ORDER BY SUM(Quantity * UnitPrice) DESC) AS country_rank
FROM online_retail
WHERE Quantity > 0 AND CustomerID IS NOT NULL
GROUP BY Country, CustomerID
) ranked
WHERE country_rank <= 5;

#16 Customer Order Frequency
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS Total_Orders
FROM online_retail
WHERE Quantity > 0 AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Total_Orders DESC
LIMIT 10;

#17. First and Last Purchase Date for Each Customer
SELECT CustomerID,
MIN(InvoiceDate) AS First_Purchase,
MAX(InvoiceDate) AS Last_Purchase
FROM online_retail
WHERE CustomerID IS NOT NULL AND Quantity > 0
GROUP BY CustomerID
ORDER BY First_Purchase;

#18. Days Between Purchases (Repeat Behavior)
SELECT CustomerID,
DATEDIFF(MAX(InvoiceDate), MIN(InvoiceDate)) AS Days_Between_First_Last_Purchase
FROM online_retail
WHERE CustomerID IS NOT NULL AND Quantity > 0
GROUP BY CustomerID
ORDER BY Days_Between_First_Last_Purchase DESC;

#19. Product Popularity by Country
SELECT Country, Description, SUM(Quantity) AS Units_Sold
FROM online_retail
WHERE Quantity > 0
GROUP BY Country, Description
ORDER BY Country, Units_Sold DESC;

#20. Revenue Trend - Week over Week
SELECT YEARWEEK(InvoiceDate) AS Week, 
ROUND(SUM(Quantity * UnitPrice), 2) AS Weekly_Revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Week
ORDER BY Week;

#21. Products That Were Never Returned
SELECT Description
FROM online_retail
WHERE Quantity > 0
GROUP BY Description
HAVING SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) = 0;

#22. Stock Keeping Units (SKU) with Highest Revenue per Unit Sold
SELECT StockCode, Description,
ROUND(SUM(Quantity * UnitPrice) / SUM(Quantity), 2) AS Revenue_per_Unit
FROM online_retail
WHERE Quantity > 0
GROUP BY StockCode, Description
ORDER BY Revenue_per_Unit DESC
LIMIT 10;

#23. High Revenue Customers with Low Order Count (Hidden Gems)
SELECT CustomerID,
COUNT(DISTINCT InvoiceNo) AS Total_Orders,
ROUND(SUM(Quantity * UnitPrice), 2) AS Total_Revenue
FROM online_retail
WHERE Quantity > 0 AND CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING Total_Orders < 5
ORDER BY Total_Revenue DESC
LIMIT 10;

#24. Time of Day Analysis (Hour-wise Sales)
SELECT HOUR(InvoiceDate) AS Hour,
ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Hour
ORDER BY Hour;

#25. Top 5 Products with Most Invoices
SELECT Description, COUNT(DISTINCT InvoiceNo) AS Invoice_Count
FROM online_retail
WHERE Quantity > 0
GROUP BY Description
ORDER BY Invoice_Count DESC
LIMIT 5;

#26. Monthly Repeat Purchase Rate (Conceptual)
WITH Monthly_Customers AS (
SELECT CustomerID, DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month
FROM online_retail
WHERE CustomerID IS NOT NULL AND Quantity > 0
GROUP BY CustomerID, Month
),
Repeaters AS (
    SELECT Month, COUNT(CustomerID) AS Repeating_Customers
    FROM (
        SELECT CustomerID, Month,
        LAG(Month) OVER (PARTITION BY CustomerID ORDER BY Month) AS Prev_Month
        FROM Monthly_Customers
    ) sub
    WHERE Prev_Month IS NOT NULL
    GROUP BY Month
)
SELECT Month, Repeating_Customers
FROM Repeaters
ORDER BY Month;
# query estimates month-over-month customer repeat activity using a CTE and window function.

#27. Most Frequently Bought Together Products (Co-occurrence Prep)
SELECT A.StockCode AS Product_A, B.StockCode AS Product_B, COUNT(*) AS Times_Bought_Together
FROM online_retail A
JOIN online_retail B ON A.InvoiceNo = B.InvoiceNo AND A.StockCode < B.StockCode
WHERE A.Quantity > 0 AND B.Quantity > 0
GROUP BY A.StockCode, B.StockCode
ORDER BY Times_Bought_Together DESC
LIMIT 10;


