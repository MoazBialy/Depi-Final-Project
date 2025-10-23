-- 06_student_improvement_rate.sql
-- Student improvement: compare Q1 vs Q2 average scores per student & subject
WITH PeriodScores AS (
    SELECT
        FS.Student_ID,
        FS.Subject_key,
        CASE
            WHEN D.Month BETWEEN 9 AND 12 THEN 'Q1'
            WHEN D.Month BETWEEN 1 AND 5 THEN 'Q2'
            ELSE 'Other'
        END AS AcademicPeriod,
        AVG(FS.Score) AS AverageScore
    FROM FactScores FS
    JOIN dim_date D ON FS.DateKey = D.DateKey
    GROUP BY FS.Student_ID, FS.Subject_key,
        CASE WHEN D.Month BETWEEN 9 AND 12 THEN 'Q1' WHEN D.Month BETWEEN 1 AND 5 THEN 'Q2' ELSE 'Other' END
)
SELECT
    ST.Full_Name,
    DS.Subject,
    Q1.AverageScore AS Q1_Average_Score,
    Q2.AverageScore AS Q2_Average_Score,
    (Q2.AverageScore - Q1.AverageScore) AS Score_Difference,
    CASE
        WHEN Q2.AverageScore > Q1.AverageScore THEN 'Improved'
        WHEN Q2.AverageScore < Q1.AverageScore THEN 'Declined'
        ELSE 'No Change'
    END AS Performance_Status
FROM PeriodScores Q1
JOIN PeriodScores Q2
    ON Q1.Student_ID = Q2.Student_ID
    AND Q1.Subject_key = Q2.Subject_key
JOIN dimStudent ST ON Q1.Student_ID = ST.Student_ID
JOIN dimSubject DS ON Q1.Subject_key = DS.Subject_key
WHERE Q1.AcademicPeriod = 'Q1' AND Q2.AcademicPeriod = 'Q2'
ORDER BY DS.Subject, Score_Difference DESC;
