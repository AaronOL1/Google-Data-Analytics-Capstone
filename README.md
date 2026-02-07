## 🚧 Project Status: Analysis Phase (In Progress)

**Objective:**
To analyze historical bike-trip data and identify key behavioral differences between Annual Members and Casual Riders, guiding the marketing strategy to convert casuals into members.

**Current Focus: SQL Data Exploration & Aggregation**
I am currently using SQL (BigQuery) to answer the foundational business questions regarding ride distribution.

**Key Technical Highlights:**
* **Window Functions:** Utilized `OVER(PARTITION BY...)` to calculate dynamic percentages and isolate daily behaviors without losing granular data.
* **Statistical Correction:** Identified a **"Base Rate Bias"** in the raw data. While Annual Members have higher ride volumes every day due to a larger population size (~64%), calculating the *Daily Market Share* reveals that Casual Riders have a significantly higher elasticity and dominance during weekends.

**Next Steps:**
* Refining the "Weekly Behavior Distribution" metrics.
* Visualizing the divergence between utility usage (Members) vs. leisure usage (Casuals) in Tableau.
