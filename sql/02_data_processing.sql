--Aggregate data by day
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

--Merge activity, sleep and weight tables
CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary` AS
SELECT
    a.user_id,
    a.activity_date,

    -- активность
    a.total_steps,
    a.total_distance,
    a.very_active_minutes,
    a.fairly_active_minutes,
    a.lightly_active_minutes,
    a.sedentary_minutes,
    a.calories,

    -- сон
    s.total_minutes_asleep,
    s.total_time_in_bed,

    -- вес
    w.weight_kg,
    w.bmi

FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean` a
INNER JOIN `maximal-plate-492011-g5.fitbit_031226_041226.sleep_clean` s
ON a.user_id = s.user_id
AND a.activity_date = DATE(s.sleep_day)
  
--Create final analytical dataset


LEFT JOIN `maximal-plate-492011-g5.fitbit_031226_041226.weight_clean` w
ON a.user_id = w.user_id
AND a.activity_date = DATE(w.date);
