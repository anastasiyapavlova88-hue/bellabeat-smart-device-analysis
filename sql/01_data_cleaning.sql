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

CREATE OR REPLACE TABLE daily_activity_clean AS
SELECT DISTINCT *
FROM daily_activity_clean;

CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean` AS
SELECT
  user_id,
  activity_date,
  MAX(total_steps) AS total_steps,
  MAX(total_distance) AS total_distance,
  MAX(tracker_distance) AS tracker_distance,
  MAX(logged_activities_distance) AS logged_activities_distance,
  MAX(moderately_active_distance) AS moderately_active_distance,
  MAX(sedentary_distance) AS sedentary_distance,
  MAX(very_active_minutes) AS very_active_minutes,
  MAX(fairly_active_minutes) AS fairly_active_minutes,
  MAX(lightly_active_minutes) AS lightly_active_minutes,
  MAX(sedentary_minutes) AS sedentary_minutes,
  MAX(calories) AS calories
FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`
GROUP BY user_id, activity_date;

SELECT user_id, activity_date, COUNT(*) AS duplicates
FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`
GROUP BY user_id, activity_date
HAVING COUNT(*) > 1;

SELECT Id, SleepDay, COUNT(*) AS duplicates
FROM sleep_day
GROUP BY Id, SleepDay
HAVING COUNT(*) > 1;

CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.sleep_day_clean` AS
SELECT DISTINCT *
FROM sleep_day_clean;

-- Standardize date formats
CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.sleep_day_clean` AS
SELECT
  CAST(Id AS INT64) AS user_id,
  DATE(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', SleepDay)) AS sleep_date,
  CAST(TotalSleepRecords AS INT64) AS sleep_records,
  CAST(TotalMinutesAsleep AS INT64) AS minutes_asleep,
  CAST(TotalTimeInBed AS INT64) AS time_in_bed
FROM `maximal-plate-492011-g5.fitbit_031226_041226.sleepDay`;

-- Handle missing values
