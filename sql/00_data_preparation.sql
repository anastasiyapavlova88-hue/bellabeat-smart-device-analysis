SELECT *
FROM maximal-plate-492011-g5.fitbit_031226_041226.dailyActivity
LIMIT 10;

--sort data
SELECT *
FROM daily_activity
ORDER BY Id, ActivityDate;

SELECT *
FROM sleep_day
ORDER BY Id, SleepDay;

SELECT *
FROM hourly_steps
ORDER BY Id, ActivityHour;

--убедиться, что данные идут хронологически и нет «сломанных» дат.
--date validation
SELECT 
    MIN(ActivityDate) AS min_date,
    MAX(ActivityDate) AS max_date
FROM daily_activity;

SELECT 
    MIN(SleepDay),
    MAX(SleepDay)
FROM sleep_day;

--unique users
SELECT COUNT(DISTINCT Id) AS unique_users
FROM daily_activity;

SELECT COUNT(DISTINCT Id) AS unique_users
FROM sleep_day;

SELECT COUNT(DISTINCT Id) AS unique_users
FROM hourly_steps;
--показать, что не все пользователи используют все функции
