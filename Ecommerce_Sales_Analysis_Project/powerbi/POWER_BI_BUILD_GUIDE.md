# Power BI Dashboard Build Guide

## 1. Load data
1. Open Power BI Desktop.
2. Home → Get data → Text/CSV → select `data/ecommerce_orders.csv`.
3. Select **Transform Data**. Confirm `OrderDate` is Date; currency/amount fields are Decimal Number; `Quantity` is Whole Number; `DiscountPct` is Decimal Number.
4. Select **Close & Apply**. Rename the table to `Orders`.

## 2. Create date table
Modeling → New table:
```DAX
DateTable = CALENDAR(MIN(Orders[OrderDate]), MAX(Orders[OrderDate]))
```
Add:
```DAX
Year = YEAR(DateTable[Date])
Month = FORMAT(DateTable[Date], "MMM")
Month Number = MONTH(DateTable[Date])
Year-Month = FORMAT(DateTable[Date], "YYYY-MM")
```
Select `DateTable[Month]` → Sort by column → `Month Number`. Create a one-to-many relationship from `DateTable[Date]` to `Orders[OrderDate]`, and mark DateTable as date table.

## 3. Add measures
Copy measures from `DAX_measures.txt` via Modeling → New measure. Format Profit Margin and Return Rate as Percentage; sales/profit/AOV as currency (₹) or whole number.

## 4. Page 1 — Executive Overview
- KPI cards: Net Sales (INR), Estimated Profit (INR), Delivered Orders, Unique Customers, Average Order Value (INR), Profit Margin %.
- Line chart: Axis `DateTable[Year-Month]`; Values `[Net Sales (INR)]`.
- Clustered bar chart: Axis `Orders[Category]`; Values `[Net Sales (INR)]`, `[Estimated Profit (INR)]`.
- Bar chart: Axis `Orders[Region]`; Values `[Net Sales (INR)]`.
- Donut chart: Legend `Orders[SalesChannel]`; Values `[Net Sales (INR)]`.
- Slicers: DateTable[Date], Orders[Region], Orders[Category], Orders[SalesChannel], Orders[PaymentMethod].

## 5. Page 2 — Product & Category
- Bar chart: Product by Net Sales (INR), sort descending, Top N = 10.
- Matrix: Category × Product with Net Sales, Units Sold, Estimated Profit.
- Scatter chart: Net Sales vs Estimated Profit by Product (optional).

## 6. Page 3 — Customers & Operations
- Bar chart: top customers by Customer sales (create customer sales measure if needed).
- Donut/bar: OrderStatus by distinct OrderID count (use all statuses; do not filter to Delivered).
- Bar chart: PaymentMethod by Net Sales.
- Card: Return Rate % and cancelled orders.

## 7. Design
Use a consistent 16:9 canvas, white/light background, dark navy headings, one accent color, aligned visuals, readable labels, and currency formatted in INR. Keep slicers in a single row or left rail. Avoid clutter.

## Important metric definition
Delivered orders are used for realized sales/profit metrics. Returned and Cancelled orders are shown separately in operational analysis. Estimated profit is simulated using assumed product margins and is not audited accounting profit.

## Save
Save as `powerbi/Ecommerce_Sales_Dashboard.pbix`. This file must be created in Power BI Desktop; this project pack includes the data, DAX, design specification and instructions but cannot create a native PBIX file automatically.
