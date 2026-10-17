# E-Commerce Sales Analysis & Dashboard

## Project overview
An end-to-end, portfolio-ready data analytics project that analyzes order performance across products, categories, regions, sales channels, payment methods, discounts, and order statuses. It includes a synthetic dataset, Excel dashboard, SQL Server analysis queries, Python analysis script, Power BI DAX measures, dashboard build guide, and preview charts.

**Important:** the dataset is synthetic and generated for learning/portfolio use. Do not describe it as real company data. Estimated profit uses simulated product-margin assumptions; it is not audited accounting profit.

## Business questions
1. What are total delivered net sales, estimated profit, delivered orders, units sold, unique customers, average order value, and profit margin?
2. How do sales and estimated profit change month by month?
3. Which product categories and products contribute most to sales?
4. Which regions perform best?
5. Which sales channel and payment methods contribute most?
6. What share of orders are delivered, returned, or cancelled?
7. How much discount is applied and how does order performance differ by category/region?

## Dataset
- File: `data/ecommerce_orders.csv` (also available as `.xlsx`)
- Rows: 1,800 orders
- Period: 2025 calendar year
- Grain: one row per order
- Currency: INR
- Fields: OrderID, OrderDate, CustomerID, Product, Category, Quantity, UnitPrice_INR, DiscountPct, GrossSales_INR, Discount_INR, NetSales_INR, EstimatedCost_INR, EstimatedProfit_INR, Region, City, SalesChannel, PaymentMethod, OrderStatus.

## KPI definitions
- **Net Sales:** gross sales minus discount, for Delivered orders only in realized-sales KPIs.
- **Estimated Profit:** Net Sales minus estimated cost. Product margin assumptions are simulated.
- **Average Order Value (AOV):** delivered net sales / delivered order count.
- **Profit Margin:** estimated profit / net sales.
- **Return Rate:** returned order count / all order count (for operational reporting).
- Returned and cancelled orders are excluded from delivered sales/profit KPIs but included in status reporting.

## Folder structure
```text
Ecommerce_Sales_Analysis_Project/
├── data/
│   ├── ecommerce_orders.csv
│   └── ecommerce_orders.xlsx
├── excel/
│   └── Ecommerce_Sales_Analysis.xlsx
├── sql/
│   └── ecommerce_schema_and_analysis.sql
├── python/
│   ├── analyze_sales.py
│   ├── requirements.txt
│   └── outputs/ (created when script runs)
├── powerbi/
│   ├── DAX_measures.txt
│   └── POWER_BI_BUILD_GUIDE.md
├── dashboard_images/
│   ├── monthly_sales_preview.png
│   ├── category_sales_preview.png
│   └── region_sales_preview.png
└── README.md
```

## How to use
### Excel
Open `excel/Ecommerce_Sales_Analysis.xlsx`. The Dashboard sheet contains KPI tiles and charts; Orders contains the raw dataset; summary tabs contain monthly/category/region/status summaries.

### Python
From the project root:
```bash
pip install -r python/requirements.txt
python python/analyze_sales.py
```
CSV outputs are written to `python/outputs/`.

### SQL Server
1. Open SQL Server Management Studio.
2. Run `sql/ecommerce_schema_and_analysis.sql` to create the database and table.
3. Import `data/ecommerce_orders.csv` into `dbo.Orders` using Import Flat File / Import Data, matching column names and types.
4. Run the analysis queries. If you create the database more than once, remove or rename the existing database first.

### Power BI
Follow `powerbi/POWER_BI_BUILD_GUIDE.md`, then use measures in `powerbi/DAX_measures.txt`. Save the finished native report as `powerbi/Ecommerce_Sales_Dashboard.pbix`.

**Note:** A native `.pbix` is not included because it must be created and saved in Power BI Desktop. The project pack includes the dataset, DAX, dashboard plan, and steps to build it.

## Suggested portfolio summary
Built an end-to-end e-commerce analytics project using Excel, SQL Server, Python (Pandas), and Power BI. Cleaned and analyzed 1,800 synthetic orders to evaluate sales trends, category and regional performance, customer activity, discounts, and order outcomes. Developed KPI summaries, SQL queries, Python-generated reports, an Excel dashboard, and a Power BI dashboard specification.

## GitHub upload checklist
- Review the dataset and dashboard outputs.
- Build and verify your Power BI report in Power BI Desktop.
- Add screenshots of the final report to `dashboard_images/`.
- Update this README with any changes you make.
- Upload the folder or ZIP contents to a new GitHub repository.
