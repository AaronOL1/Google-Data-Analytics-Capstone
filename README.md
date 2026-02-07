# 🚴 Cyclistic Bike-Share Analysis (Google Capstone)

## 📌 1. Introduction
**Project:** Google Data Analytics Professional Certificate - Capstone Project.
**Role:** Junior Data Analyst at Cyclistic, a bike-share company in Chicago.
**Goal:** Design marketing strategies to convert casual riders into annual members.

## ❓ 2. Business Task (The "Ask" Phase)
The director of marketing, **Lily Moreno**, believes the company’s future success depends on maximizing the number of annual memberships [1]. Therefore, my team wants to understand how casual riders and annual members use Cyclistic bikes differently.

**Primary Question:**
* How do annual members and casual riders use Cyclistic bikes differently?

**Key Stakeholders:**
* **Lily Moreno:** Director of Marketing.
* **Cyclistic Executive Team:** Detail-oriented executive team responsible for approval.

## 📂 3. Data Source (The "Prepare" Phase)
* **Source:** Public data provided by **Motivate International Inc.** (Divvy Trip Data).
* **Format:** 12 Monthly CSV files containing ride data (Ride ID, timestamps, station info, user type).
* **License:** [Data License Agreement](https://ride.divvybikes.com/data-license-agreement).
* *Note: Data privacy is protected; no personal user information is available.*

## 🛠️ 4. Tools Used
* **SQL Server:** For Data Cleaning, Unioning (merging 12 months), and Analysis.
* **Power BI / Tableau:** For Data Visualization and Dashboarding.

## 📊 5. Key Insights (The "Analyze" Phase)
Through SQL analysis, two distinct user profiles emerged based on ride duration, frequency, and consistency:

### 👤 The "Efficient Commuter" (Annual Members)
* **Routine:** Consistent usage Mon-Fri with minimal daily variance.
* **Duration:** Short, flat travel times (**~12-13 mins**) indicating A-to-B utility trips.
* **Consistency:** **Low Standard Deviation (31.29)**, mathematically proving highly predictable behavior.
* **Seasonality:** Maintains a "base load" of activity even in winter (necessity-based travel).

### 🌍 The "Weekend Explorer" (Casual Riders)
* **Routine:** Usage spikes dramatically on weekends (Sat/Sun).
* **Duration:** Rides are ~2x longer (**~26 mins**), confirming leisure/recreational intent.
* **Consistency:** **High Standard Deviation (81.42)**, proving chaotic/unstructured usage patterns.
* **Seasonality:** Activity drops by ~92% in winter (fair-weather dependence).

## 📈 6. Deliverables Status
- [x] 1. A clear statement of the business task.
- [x] 2. A description of all data sources used.
- [x] 3. Documentation of any cleaning or manipulation of data.
- [x] 4. A summary of analysis.
- [ ] 5. Supporting visualizations and key findings.
- [ ] 6. Top three recommendations.