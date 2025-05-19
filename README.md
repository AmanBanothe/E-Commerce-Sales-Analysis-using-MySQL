# 🛒 E-Commerce-Sales-Analysis-using-MySQL

📌 Project Overview
This project analyzes real-world transactional data from a UK-based online retail company. The analysis is performed using MySQL to uncover valuable business insights such as sales trends, product performance, customer segmentation, and revenue patterns.

🔍 **Objective**: Derive actionable insights from raw transactional data using SQL for business decisions.

📂 Dataset Description
📥 Source: UCI Machine Learning Repository
https://archive.ics.uci.edu/ml/machine-learning-databases/00352
📁 Format: Excel (.xlsx) converted to CSV

📊 Transactions: ~500,000

📅 Period: December 2010 – December 2011

🌍 Region: Primarily United Kingdom

🧾 Key Columns:
Column        :	Description
InvoiceNo	    :  Unique ID per transaction
StockCode	    :  Product code
Description	  :  Product name
Quantity	    :  Items purchased (can be negative)
InvoiceDate	  :  Timestamp of purchase
UnitPrice	    :  Price per item (GBP)
CustomerID	  :  Unique ID per customer
Country	      :  Customer location


📊 Key SQL Queries & Analysis
✅ Revenue Metrics
-- Total Revenue
SELECT ROUND(SUM(Quantity * UnitPrice), 2) AS Total_Revenue
FROM online_retail
WHERE Quantity > 0;

🏆 Top 10 Products by Revenue
SELECT Description, ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Description
ORDER BY Revenue DESC
LIMIT 10;

📈 Monthly Sales Trend
SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
       ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Month
ORDER BY Month;

🌍 Revenue by Country
SELECT Country, ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Country
ORDER BY Revenue DESC;

🔄 Cancelled Orders Analysis
SELECT COUNT(*) AS Cancelled_Orders, 
       ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue_Lost
FROM online_retail
WHERE InvoiceNo LIKE 'C%';

💡 More Queries:
   > Average Basket Size & Order Value

   > First and Last Purchase Date per Customer

   > Top Customers by Lifetime Value
   
   > Product Return Rates
   
   > Time-of-Day Revenue Patterns
   
   > Co-Purchased Products
   
   > Monthly Active Users


🧾 Folder Structure
ecommerce-mysql-analysis/
  
│

├── OnlineRetail.csv                     # Raw dataset

├── ecommerce_analysis.sql               # SQL queries for analysis

├── schema.sql                           # Table schema

├── insights.md                          # Summary of findings

└── README.md                            # Project overview and details

📌 How to Use
Import **OnlineRetail.csv** to MySQL using MySQL Workbench or CLI.

Run schema.sql to create the table.

Run **ecommerce_analysis.sql** for insights.

📚 Credits
Dataset from UCI Machine Learning Repository

Inspired by retail business case studies in analytics
