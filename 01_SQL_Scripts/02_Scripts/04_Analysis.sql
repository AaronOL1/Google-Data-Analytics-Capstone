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
    -- QUESTION: What is the market share of Members vs Casuals?
SELECT member_casual, 
       COUNT(ride_id) AS total_rides,
       CAST(
        ROUND(COUNT(ride_id)*100.0/ (SELECT COUNT(*) FROM Cyclistic_Final), 2)
       AS DECIMAL(5,2)) AS market_share_percentage
FROM Cyclistic_Final
GROUP BY member_casual;

-- INSIGHTS: Members: 63,99%; Casual: 36,01%.

    -- QUESTION: Who rides mode timely media? (Members vs Casuals)
/*
MISIÓN 2: El Factor Tiempo (Duración)
Pregunta: ¿Quién se queda más tiempo con la bici en promedio?
Pista: Usa AVG en la columna de duración (minutos).
Tu hipótesis a validar: "Los Members van rápido al trabajo 
(tiempo corto). Los Casuals pasean (tiempo largo)".
*/

SELECT
    member_casual,
    CAST(
        AVG(ride_length_minutes) 
    AS DECIMAL (5,2)) AS avg_ride_length_minutes
FROM Cyclistic_Final
GROUP BY member_casual

-- INSIGHTS: Members: 12.33 minutes; Casuals: 22.60 minutes.
--           Correct Hypotesys: Casuals ride 10.27 mins longer than Members (45.44% more), 
--           supporting the idea that Casuals use bikes for leisure.

-- QUESTION 3: Wich days of the week do Members vs Casuals ride more?

SELECT
    day_of_week,
    member_casual,
    COUNT(ride_id) AS total_rides,
    CAST(
        ROUND(
            COUNT(ride_id)*100.0/ SUM(COUNT(ride_id)) OVER (PARTITION BY day_of_week)
            , 2) AS DECIMAL (5,2))AS percentage_of_daily_ride 
FROM Cyclistic_Final
GROUP BY day_of_week,member_casual
ORDER BY day_of_week, member_casual;

-- INSIGHTS:
-- 1. Volume Dominance: Members consistently record higher ride volumes than casual users every day of the week.
-- 2. Statistical Note: This reflects a "Base Rate Bias". Since the Member population is roughly double that of Casuals, higher absolute numbers are expected.
-- 3. Metric Definition: This query calculates the "Daily Market Share" (composition of total daily rides).




-- STRATEGIC RECOMMENDATION:
-- Given that 1 in 4 patients visi 




