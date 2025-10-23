-- 03_average_score_per_month.sql
-- Average score per month
SELECT
    d.MonthName,
    AVG(f.Score) AS AverageScore
FROM FactScores f
JOIN dim_date d ON f.DateKey = d.DateKey
GROUP BY d.Month, d.MonthName
ORDER BY d.Month;
