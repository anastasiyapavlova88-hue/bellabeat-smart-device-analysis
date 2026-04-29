-- Fix data types
CREATE OR REPLACE TABLE daily_activity_clean AS
SELECT
  CAST(Id AS INT64) AS user_id,
  PARSE_DATE('%m/%d/%Y', ActivityDate) AS activity_date,
  CAST(TotalSteps AS INT64) AS total_steps,
  CAST(TotalDistance AS FLOAT64) AS total_distance,
  CAST(VeryActiveDistance AS FLOAT64) AS very_active_distance,
  CAST(ModeratelyActiveDistance AS FLOAT64) AS moderately_active_distance,
  CAST(LightActiveDistance AS FLOAT64) AS light_active_distance,
  CAST(SedentaryActiveDistance AS FLOAT64) AS sedentary_distance,
  CAST(VeryActiveMinutes AS INT64) AS very_active_minutes,
  CAST(FairlyActiveMinutes AS INT64) AS fairly_active_minutes,
  CAST(LightlyActiveMinutes AS INT64) AS lightly_active_minutes,
  CAST(SedentaryMinutes AS INT64) AS sedentary_minutes,
  CAST(Calories AS INT64) AS calories
FROM raw_daily_activity; 

-- Remove duplicates
SELECT Id, ActivityDate, COUNT(*) AS duplicates
FROM daily_activity
GROUP BY Id, ActivityDate
HAVING COUNT(*) > 1;

SELECT Id, SleepDay, COUNT(*) AS duplicates
FROM sleep_day
GROUP BY Id, SleepDay
HAVING COUNT(*) > 1;

-- Standardize date formats
-- Handle missing values
