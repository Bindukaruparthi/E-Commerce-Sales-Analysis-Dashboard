"""
E-Commerce Sales Analysis
Run from the project root:
    pip install -r python/requirements.txt
    python python/analyze_sales.py
Outputs summary CSVs in python/outputs/.
Dataset is synthetic and intended for portfolio/learning use.
"""
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "ecommerce_orders.csv"
OUT = ROOT / "python" / "outputs"
OUT.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(DATA, parse_dates=["OrderDate"])
# Basic data quality checks
print("Shape:", df.shape)
print("Duplicate OrderIDs:", df["OrderID"].duplicated().sum())
print("Missing values by column:\n", df.isna().sum())
print("Order status counts:\n", df["OrderStatus"].value_counts())

# Define completed orders for realized KPI reporting
completed = df[df["OrderStatus"] == "Delivered"].copy()
completed["Month"] = completed["OrderDate"].dt.to_period("M").astype(str)

kpis = pd.DataFrame({
    "Metric": ["Delivered Orders", "Unique Customers", "Units Sold", "Net Sales (INR)",
               "Estimated Profit (INR)", "Average Order Value (INR)", "Profit Margin"],
    "Value": [completed["OrderID"].nunique(), completed["CustomerID"].nunique(),
              completed["Quantity"].sum(), completed["NetSales_INR"].sum(),
              completed["EstimatedProfit_INR"].sum(),
              completed["NetSales_INR"].sum() / max(completed["OrderID"].nunique(), 1),
              completed["EstimatedProfit_INR"].sum() / max(completed["NetSales_INR"].sum(), 1)]
})
kpis.to_csv(OUT / "kpi_summary.csv", index=False)
completed.groupby("Category", as_index=False).agg(
    Orders=("OrderID", "nunique"), Units=("Quantity", "sum"),
    NetSales_INR=("NetSales_INR", "sum"), EstimatedProfit_INR=("EstimatedProfit_INR", "sum")
).sort_values("NetSales_INR", ascending=False).to_csv(OUT / "category_summary.csv", index=False)
completed.groupby("Region", as_index=False).agg(
    Orders=("OrderID", "nunique"), NetSales_INR=("NetSales_INR", "sum"),
    EstimatedProfit_INR=("EstimatedProfit_INR", "sum")
).sort_values("NetSales_INR", ascending=False).to_csv(OUT / "region_summary.csv", index=False)
completed.groupby("Month", as_index=False).agg(
    Orders=("OrderID", "nunique"), NetSales_INR=("NetSales_INR", "sum"),
    EstimatedProfit_INR=("EstimatedProfit_INR", "sum")
).to_csv(OUT / "monthly_trend.csv", index=False)
df.groupby("OrderStatus", as_index=False).agg(Orders=("OrderID", "nunique")).to_csv(OUT / "status_summary.csv", index=False)

# Save a chart for quick preview
monthly = completed.groupby(completed["OrderDate"].dt.to_period("M"))["NetSales_INR"].sum()
ax = monthly.plot(kind="line", marker="o", figsize=(10, 5), title="Monthly Net Sales — Delivered Orders")
ax.set_xlabel("Month")
ax.set_ylabel("Net Sales (INR)")
plt.tight_layout()
plt.savefig(ROOT / "dashboard_images" / "monthly_sales_preview.png", dpi=160)
plt.close()
print(f"Analysis complete. Outputs saved to {OUT}")
