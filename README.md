# 🚴‍♂️ Cyclistic Bike-Share Analysis (Google Data Analytics Capstone)

## 📌 Project Overview
**Goal:** Design marketing strategies to convert casual riders into annual members by analyzing historical bike trip data.
**Role:** Junior Data Analyst
**Tools:** SQL Server (SSMS) for Data Cleaning & Analysis.
**Dataset:** 12 months of historical trip data (5.7 million rows).

## 🔍 Key Insights (Behavioral Segmentation)
Through SQL analysis, two distinct user profiles emerged:

* **1. The "Efficient Commuter" (Annual Members)**
    * **Routine:** Consistent usage Mon-Fri with minimal variance.
    * **Duration:** Short, flat travel times (~12-13 mins) indicating A-to-B utility trips.
    * **Consistency:** Low Standard Deviation (31.29), proving highly predictable behavior.
    * **Seasonality:** Maintains activity in winter (necessity-based travel).

* **2. The "Weekend Explorer" (Casual Riders)**
    * **Routine:** Usage spikes dramatically on weekends (Sat/Sun).
    * **Duration:** Rides are ~2x longer (~26 mins), confirming leisure/recreational intent.
    * **Consistency:** High Standard Deviation (81.42), proving chaotic/unstructured usage.
    * **Seasonality:** Activity drops by ~92% in winter (fair-weather dependence).

## 🛠️ SQL Skills Demonstrated
* **Data Cleaning:** Handling NULLs, duplicate removal, and data type casting.
* **Analysis:** Aggregations (`GROUP BY`), Date functions (`DATENAME`, `DATEPART`).
* **Advanced SQL:**
    * `CTEs` (Common Table Expressions) for complex calculations.
    * `Window Functions` (`OVER`, `PARTITION BY`) for market share analysis.
    * Statistical functions (`STDEV`) for volatility analysis.

## 📂 Project Structure
* `01_Data_Cleaning.sql`: Standardization and null handling.
* `02_Data_Analysis.sql`: Exploratory analysis and KPI calculation.
* `03_Final_Insights.sql`: Determining user profiles (Commuter vs. Explorer).

---
*Analysis by Aaron Olmedo | February 2026*