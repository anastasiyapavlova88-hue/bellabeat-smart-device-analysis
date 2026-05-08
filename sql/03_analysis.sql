--check number of users and days
SELECT
  COUNT(DISTINCT user_id) AS users,
  COUNT(*) AS total_days
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary`;

--check null
SELECT
  COUNTIF(total_minutes_asleep IS NULL) AS missing_sleep,
  COUNTIF(weight_kg IS NULL) AS missing_weight
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary`;

--descriptive users statistics
SELECT
  ROUND(AVG(total_steps),0) AS avg_steps,
  MIN(total_steps) AS min_steps,
  MAX(total_steps) AS max_steps
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary`;

--sleep
SELECT
  ROUND(AVG(total_minutes_asleep),0) AS avg_sleep_min,
  ROUND(AVG(total_minutes_asleep)/60,2) AS avg_sleep_hours
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary`;

--sedetary time
SELECT
  ROUND(AVG(sedentary_minutes)/60,2) AS avg_sedentary_hours
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary`;

--create table user activity level
CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.user_activity_level` AS
SELECT
  user_id,
  AVG(total_steps) AS avg_steps,

  CASE
    WHEN AVG(total_steps) < 5000 THEN 'sedentary'
    WHEN AVG(total_steps) BETWEEN 5000 AND 7499 THEN 'low_active'
    WHEN AVG(total_steps) BETWEEN 7500 AND 9999 THEN 'somewhat_active'
    ELSE 'active'
  END AS activity_level

FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary`
GROUP BY user_id;

--number of users in every group
SELECT
  activity_level,
  COUNT(*) AS users
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_activity_level`
GROUP BY activity_level
ORDER BY users DESC;

--correletion between activity and calories
SELECT
  ROUND(CORR(total_steps, calories),3) AS steps_calories_corr
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary`;

--correlation between sleep and activity
SELECT
  ROUND(CORR(total_steps, total_minutes_asleep),3) AS steps_sleep_corr
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary`;

SELECT
  u.activity_level,
  ROUND(AVG(d.total_minutes_asleep)/60,2) AS avg_sleep_hours
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary` d
JOIN `maximal-plate-492011-g5.fitbit_031226_041226.user_activity_level` u
USING(user_id)
GROUP BY activity_level;

--weekdays vs weekends
SELECT
  FORMAT_DATE('%A', activity_date) AS day_of_week,
  ROUND(AVG(total_steps),0) AS avg_steps
FROM `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary`
GROUP BY day_of_week
ORDER BY avg_steps DESC;

--final table
CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.user_daily_summary` AS
SELECT
    a.user_id,
    a.activity_date,

    a.total_steps,
    a.total_distance,
    a.very_active_minutes,
    a.fairly_active_minutes,
    a.lightly_active_minutes,
    a.sedentary_minutes,
    a.calories,

    -- заменяем NULL сна на 0
    IFNULL(s.total_minutes_asleep,0) AS total_minutes_asleep,
    IFNULL(s.total_time_in_bed,0) AS total_time_in_bed,

    -- заменяем NULL веса на 0
    IFNULL(w.weight_kg,0) AS weight_kg,
    IFNULL(w.bmi,0) AS bmi

FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean` a

LEFT JOIN `maximal-plate-492011-g5.fitbit_031226_041226.sleep_clean` s
ON a.user_id = s.user_id
AND a.activity_date = DATE(s.sleep_day)

LEFT JOIN `maximal-plate-492011-g5.fitbit_031226_041226.weight_clean` w
ON a.user_id = w.user_id
AND a.activity_date = DATE(w.date);


