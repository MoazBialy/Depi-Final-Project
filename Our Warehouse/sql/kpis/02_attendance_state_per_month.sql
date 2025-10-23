-- 02_attendance_state_per_month.sql
-- Attendance state aggregated per month
SELECT
    d.MonthName AS [Month],
    SUM(CASE WHEN f.Attendance_status_key = 1 THEN 1 ELSE 0 END) AS Present,
    SUM(CASE WHEN f.Attendance_status_key = 2 THEN 1 ELSE 0 END) AS Excused,
    SUM(CASE WHEN f.Attendance_status_key = 3 THEN 1 ELSE 0 END) AS Late,
    SUM(CASE WHEN f.Attendance_status_key = 4 THEN 1 ELSE 0 END) AS Absent,
    SUM(CASE WHEN f.Attendance_status_key = 5 THEN 1 ELSE 0 END) AS [Left Early]
FROM FactAttendance f
JOIN dim_date d ON f.DateKey = d.DateKey
GROUP BY d.Month, d.MonthName
ORDER BY d.Month;
