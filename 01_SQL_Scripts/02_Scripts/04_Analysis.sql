/*
=============================================================================
PROJECT: GOOGLE CAPSTONE - CYCLISTIC BIKE SHARE
FILE: 04_Analysis.sql
AUTHOR: Aaron Olmedo
DATE: Feb 5, 2026
-----------------------------------------------------------------------------
1. BUSINESS CONTEXT (SITUATION)
- Company: Cyclistic, a bike-share company in Chicago (5,800 bikes, 600 stations).
- The Problem: Annual members are significantly more profitable than casual riders.
- The Goal: Design marketing strategies to convert casual riders into annual members.

-----------------------------------------------------------------------------
2. BUSINESS TASK (OBJECTIVE)
- Primary Question: How do annual members and casual riders use Cyclistic bikes differently?
- Deliverable: Insights and trends to support the new marketing strategy.

-----------------------------------------------------------------------------
3. HYPOTHESES (WHAT WE EXPECT TO FIND)
- H1: "Members" use bikes for commuting (Work/School).
      -> Expectation: Peaks Mon-Fri, approx 8am & 5pm. Short duration.
- H2: "Casuals" use bikes for leisure/tourism.
      -> Expectation: Peaks Sat-Sun. Longer duration (wandering).
-- =============================================================================
-- DATA LIMITATION NOTE:
-- According to the case study, Cyclistic offers reclining bikes, hand tricycles,
-- and cargo bikes, with approx. 8% of riders using these assistive options.
-- However, the provided dataset only distinguishes between "classic_bike" 
-- and "electric_bike".
-- 
-- ANALYST ASSUMPTION: The assistive/specialty bikes are likely aggregated 
-- under the "classic_bike" category. The analysis will proceed using the 
-- available explicit categories found in the database.
-- ==========================================================================

*/

USE Cyclistic_2025;
GO

SELECT DISTINCT rideable_type
FROM Cyclistic_Final;

-- 1. METRIC 1: GLOBAL MARKET SHARE 
    -- QUESTION 1: What is the market share of Members vs Casuals?
SELECT member_casual, 
       COUNT(ride_id) AS total_rides,
       CAST(
        ROUND(COUNT(ride_id)*100.0/ (SELECT COUNT(*) FROM Cyclistic_Final), 2)
       AS DECIMAL(5,2)) AS market_share_percentage
FROM Cyclistic_Final
GROUP BY member_casual;

-- INSIGHTS: Members: 63,99%; Casual: 36,01%.
-----------------------------------------------------------
-- QUESTION 3: Wich days of the week do Members vs Casuals ride more?

-- STEP 1: VOLUME ANALYSIS (Market Share per Day)
-- Goal: See who dominates the total rides each day.
SELECT
    day_of_week,
    member_casual,
    COUNT(ride_id) AS total_rides,
    CAST(
        ROUND(
            COUNT(ride_id)*100.0/ SUM(COUNT(ride_id)) OVER (PARTITION BY day_of_week)
            , 2) AS DECIMAL (5,2))AS perc_of_daily_ride 
FROM Cyclistic_Final
GROUP BY day_of_week,member_casual
ORDER BY day_of_week, member_casual;

-- INSIGHTS STEP 1:
-- Members dominate volume every single day (due to larger population).
-- We need to normalize data to see "Behavioral Preference" instead of just volume.


-- STEP 2: PREFERENCE ANALYSIS (The Real Insight)
-- Goal: Identify the preferred days for each specific group (Internal Distribution).

SELECT
    day_of_week,
    member_casual,
    COUNT(ride_id) AS total_rides,
    CAST(
        ROUND(
            COUNT(ride_id)*100.0/ SUM(COUNT(ride_id)) OVER (PARTITION BY member_casual), 2) 
            AS DECIMAL (5,2))AS perc_of_weekly_activity 
FROM Cyclistic_Final
GROUP BY day_of_week,member_casual
ORDER BY member_casual, day_of_week;

-- INSIGHTS STEP 2:
-- CASUALS: Weekend Warriors. ~40% of their total rides happen on Day 1 & 7.
-- MEMBERS: Daily Commuters. Consistent usage Mon-Fri (~15% daily), drops on weekends.


-- STEP 3: DATA VALIDATION
-- Goal: Confirm Week starts with Sunday (Sunday=1).

SELECT DISTINCT day_of_week, DATENAME(WEEKDAY, started_at) as day_name
FROM Cyclistic_Final
ORDER BY day_of_week;

/* FINAL CONCLUSION - QUESTION 3
   1. VALIDATION: Confirmed week starts with Sunday (1=Sunday, 7=Saturday).
   2. CASUAL PROFILE: Leisure-oriented. High dependency on weekends (Sat/Sun).
   3. MEMBER PROFILE: Utility-oriented. High dependency on workdays (Mon-Fri).
   4. STRATEGY: Target Casuals with ads on Friday/Saturday.
*/

-------------------------------------------------------------------------------
-- QUESTION 2 & 4: Duration Statistics (General)

--STEP 1: RIDE DURATION ANALYSIS

SELECT
    member_casual,
    CAST(AVG(ride_length_minutes)AS DECIMAL(7,2)) AS avg_ride_length_minutes,
    CAST (MAX(ride_length_minutes) AS INT) AS max_ride_length_minutes
FROM Cyclistic_Final
GROUP BY member_casual
ORDER BY member_casual, avg_ride_length_minutes, max_ride_length_minutes;

-- INSIGHTS STEP 1:
    -- CASUALS: Longer rides (avg 22.6 mins, max 1574 mins)
    -- MEMBERS: Shorter rides (avg 12.33 mins, max 1500 mins)

-- QUESTION 5. Seasonality (months)

SELECT
    member_casual,
    MONTH(started_at) AS month_num,
    DATENAME(MONTH, started_at) AS month_name,
    COUNT(ride_id) AS total_rides
FROM Cyclistic_Final
GROUP BY member_casual, MONTH(started_at), DATENAME(MONTH, started_at)
ORDER BY member_casual, month_num 
;


-- INSIGHTS STEP 2:
--    Both groups are affected by Chicago's winter, but Casuals "hibernate" completely.
--    Casuals drop by ~92% in Winter (Jan vs Aug); Members drop by ~75% in Winter (Dec vs Aug).
--    Best time for marketing is June to September.
--    July/August are the absolute peaks for both groups.

WITH Monthly_Counts AS (
    SELECT
        member_casual,
        MONTH(started_at) AS month_num,
        DATENAME(MONTH, started_at) AS month_name,
        COUNT(ride_id) AS total_rides
    FROM Cyclistic_Final
    GROUP BY member_casual, MONTH(started_at), DATENAME(MONTH, started_at)
)
SELECT 
    member_casual,
    MIN (total_rides) AS min_month_rides,
    MAX (total_rides) AS max_month_rides,
    CAST(MAX(total_rides)*1.0/MIN(total_rides) AS DECIMAL(7,2)) AS growth_factor
FROM Monthly_Counts
GROUP BY member_casual
;

-- INSIGHTS:
-- Casuals: Growth Factor ~14.01x (Extremely volatile)
-- Members: Growth Factor ~4.02 x (Much more stable).

-- QUESTION 6. AVERAGE DURATION BY DAY OF WEEK
--Necesito: dias de la semana, tipo de usuario, duracion promedio

SELECT
    member_casual,
    day_of_week,
    DATENAME(WEEKDAY,started_at) AS day_name,
    CAST(AVG(ride_length_minutes) AS DECIMAL(7,2)) AS avg_ride_mins
FROM Cyclistic_Final
GROUP BY day_of_week, DATENAME(WEEKDAY, started_at),member_casual
ORDER BY member_casual, day_of_week
;

--Standar Deviation Analysis (Optional)
SELECT
    member_casual,
    CAST(AVG(ride_length_minutes) AS DECIMAL (7,2)) AS avg_duration,
    CAST(STDEV(ride_length_minutes) AS DECIMAL (7,2)) AS consistency_score
FROM Cyclistic_Final
GROUP BY member_casual
;

-- INSIGHTS:
-- 1. Members are highly predictable (SD: 31.29), confirming a fixed A-to-B routine. Casuals are erratic (SD: 81.42), proving unstructured leisure use.
-- 2. Casuals spike on weekends (~26 mins), while Members remain efficient (~12-13 mins) all week.
-- 3. CONCLUSION: The data mathematically defines Members as "Commuters" (Low Variance) and Casuals as "Explorers" (High Variance).