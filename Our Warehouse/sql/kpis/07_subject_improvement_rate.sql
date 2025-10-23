-- 07_subject_improvement_rate.sql
-- Subject-level improvement aggregated across students (Q1 vs Q2)
WITH PeriodScores AS (
    SELECT
        FS.Student_ID,
        FS.Subject_key,
        CASE
            WHEN D.Month BETWEEN 9 AND 12 THEN 'Q1'
            WHEN D.Month BETWEEN 1 AND 5 THEN 'Q2'
            ELSE 'Other'
        END AS AcademicPeriod,
        AVG(FS.Score) AS StudentAverageScore
    FROM FactScores FS
    JOIN dim_date D ON FS.DateKey = D.DateKey
    GROUP BY FS.Student_ID, FS.Subject_key,
        CASE WHEN D.Month BETWEEN 9 AND 12 THEN 'Q1' WHEN D.Month BETWEEN 1 AND 5 THEN 'Q2' ELSE 'Other' END
)
SELECT
    DS.Subject,
    AVG(CASE WHEN Q1.AcademicPeriod = 'Q1' THEN Q1.StudentAverageScore END) AS Q1_Overall_Avg_Score,
    AVG(CASE WHEN Q2.AcademicPeriod = 'Q2' THEN Q2.StudentAverageScore END) AS Q2_Overall_Avg_Score,
    SUM(CASE WHEN Q2.StudentAverageScore > Q1.StudentAverageScore THEN 1 ELSE 0 END) AS ImprovedStudents,
    COUNT(Q1.Student_ID) AS TotalStudentsInBothPeriods,
    CASE
        WHEN AVG(CASE WHEN Q2.AcademicPeriod = 'Q2' THEN Q2.StudentAverageScore END) > AVG(CASE WHEN Q1.AcademicPeriod = 'Q1' THEN Q1.StudentAverageScore END) THEN 'Improved'
        WHEN AVG(CASE WHEN Q2.AcademicPeriod = 'Q2' THEN Q2.StudentAverageScore END) < AVG(CASE WHEN Q1.AcademicPeriod = 'Q1' THEN Q1.StudentAverageScore END) THEN 'Declined'
        ELSE 'No Change'
    END AS Subject_Performance_Trend
FROM PeriodScores Q1
JOIN PeriodScores Q2
    ON Q1.Student_ID = Q2.Student_ID
    AND Q1.Subject_key = Q2.Subject_key
JOIN dimSubject DS ON Q1.Subject_key = DS.Subject_key
WHERE Q1.AcademicPeriod = 'Q1' AND Q2.AcademicPeriod = 'Q2'
GROUP BY DS.Subject;
