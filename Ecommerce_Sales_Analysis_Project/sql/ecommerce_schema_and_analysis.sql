/*
E-Commerce Sales Analysis — SQL Server
Run ecommerce_schema_and_analysis.sql in SQL Server Management Studio.
The CSV columns align with this table. Import CSV using the Import Flat File wizard
or use the Excel dataset as a source. Currency values are INR.
*/
CREATE DATABASE EcommerceSalesDB;
GO
USE EcommerceSalesDB;
GO

CREATE TABLE dbo.Orders (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID VARCHAR(20) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Category VARCHAR(60) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice_INR DECIMAL(12,2) NOT NULL,
    DiscountPct DECIMAL(5,4) NOT NULL,
    GrossSales_INR DECIMAL(14,2) NOT NULL,
    Discount_INR DECIMAL(14,2) NOT NULL,
    NetSales_INR DECIMAL(14,2) NOT NULL,
    EstimatedCost_INR DECIMAL(14,2) NOT NULL,
    EstimatedProfit_INR DECIMAL(14,2) NOT NULL,
    Region VARCHAR(30) NOT NULL,
    City VARCHAR(60) NOT NULL,
    SalesChannel VARCHAR(30) NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL,
    OrderStatus VARCHAR(30) NOT NULL
);
GO

-- 1. Overall order counts by status
SELECT OrderStatus, COUNT(*) AS OrderCount
FROM dbo.Orders GROUP BY OrderStatus ORDER BY OrderCount DESC;

-- 2. Core KPIs for delivered orders only
SELECT
    COUNT(*) AS DeliveredOrders,
    COUNT(DISTINCT CustomerID) AS UniqueCustomers,
    SUM(Quantity) AS UnitsSold,
    SUM(NetSales_INR) AS NetSalesINR,
    SUM(EstimatedProfit_INR) AS EstimatedProfitINR,
    CAST(SUM(NetSales_INR) / NULLIF(COUNT(*), 0) AS DECIMAL(14,2)) AS AverageOrderValueINR,
    CAST(SUM(EstimatedProfit_INR) / NULLIF(SUM(NetSales_INR), 0) AS DECIMAL(9,4)) AS ProfitMargin
FROM dbo.Orders WHERE OrderStatus = 'Delivered';

-- 3. Monthly sales trend
SELECT YEAR(OrderDate) AS SalesYear, MONTH(OrderDate) AS SalesMonth,
       SUM(NetSales_INR) AS NetSalesINR, SUM(EstimatedProfit_INR) AS EstimatedProfitINR
FROM dbo.Orders WHERE OrderStatus = 'Delivered'
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth;

-- 4. Category performance
SELECT Category, COUNT(*) AS Orders, SUM(Quantity) AS Units,
       SUM(NetSales_INR) AS NetSalesINR, SUM(EstimatedProfit_INR) AS EstimatedProfitINR
FROM dbo.Orders WHERE OrderStatus = 'Delivered'
GROUP BY Category ORDER BY NetSalesINR DESC;

-- 5. Regional performance
SELECT Region, COUNT(*) AS Orders, SUM(NetSales_INR) AS NetSalesINR,
       SUM(EstimatedProfit_INR) AS EstimatedProfitINR
FROM dbo.Orders WHERE OrderStatus = 'Delivered'
GROUP BY Region ORDER BY NetSalesINR DESC;

-- 6. Top 10 products by delivered net sales
SELECT TOP 10 Product, SUM(Quantity) AS UnitsSold, SUM(NetSales_INR) AS NetSalesINR,
       SUM(EstimatedProfit_INR) AS EstimatedProfitINR
FROM dbo.Orders WHERE OrderStatus = 'Delivered'
GROUP BY Product ORDER BY NetSalesINR DESC;

-- 7. Sales channel contribution
SELECT SalesChannel, SUM(NetSales_INR) AS NetSalesINR,
       CAST(100.0 * SUM(NetSales_INR) / NULLIF(SUM(SUM(NetSales_INR)) OVER (),0) AS DECIMAL(6,2)) AS SalesSharePct
FROM dbo.Orders WHERE OrderStatus = 'Delivered'
GROUP BY SalesChannel ORDER BY NetSalesINR DESC;

-- 8. Payment method analysis
SELECT PaymentMethod, COUNT(*) AS Orders, SUM(NetSales_INR) AS NetSalesINR
FROM dbo.Orders WHERE OrderStatus = 'Delivered'
GROUP BY PaymentMethod ORDER BY NetSalesINR DESC;

-- 9. Return/cancellation rate
SELECT OrderStatus, COUNT(*) AS Orders,
       CAST(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM dbo.Orders),0) AS DECIMAL(6,2)) AS SharePct
FROM dbo.Orders GROUP BY OrderStatus ORDER BY Orders DESC;

-- 10. Customer value ranking among delivered orders
SELECT CustomerID, COUNT(*) AS DeliveredOrders,
       SUM(NetSales_INR) AS CustomerSalesINR,
       SUM(EstimatedProfit_INR) AS CustomerProfitINR
FROM dbo.Orders WHERE OrderStatus = 'Delivered'
GROUP BY CustomerID ORDER BY CustomerSalesINR DESC;
