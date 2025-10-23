-- 04_attendance_score_correlation.sql
-- Correlate student absence count with average score
WITH StudentAbsence AS (
    SELECT
        Student_ID,
        COUNT(CASE WHEN Attendance_Status_key = 4 THEN 1 END) AS TotalAbsentDays
    FROM FactAttendance
    GROUP BY Student_ID
),
StudentAvgScore AS (
    SELECT
        Student_ID,
        AVG(Score) AS AverageScore
    FROM FactScores
    GROUP BY Student_ID
)
SELECT
    ST.Full_Name AS StudentName,
    SA.TotalAbsentDays,
    SAS.AverageScore,
    CASE
        WHEN SA.TotalAbsentDays > 5 THEN 'High Absence'
        WHEN SA.TotalAbsentDays < 2 THEN 'Low Absence'
        ELSE 'Normal'
    END AS AbsenceGroup_Category
FROM StudentAvgScore SAS
JOIN StudentAbsence SA ON SAS.Student_ID = SA.Student_ID
JOIN dimStudent ST ON SAS.Student_ID = ST.Student_ID
ORDER BY SA.TotalAbsentDays DESC;
