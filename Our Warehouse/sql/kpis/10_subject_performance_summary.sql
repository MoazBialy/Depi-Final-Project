-- 10_subject_performance_summary.sql
-- Average score per student per subject with letter grade
SELECT
    ST.Full_Name AS Student_Name,
    S.Subject AS Subject_Name,
    AVG(FS.Score) AS Average_Score_Per_Subject,
    CASE
        WHEN AVG(FS.Score) >= 90 THEN 'A'
        WHEN AVG(FS.Score) >= 80 THEN 'B'
        WHEN AVG(FS.Score) >= 70 THEN 'C'
        WHEN AVG(FS.Score) >= 60 THEN 'D'
        ELSE 'F'
    END AS Letter_Grade
FROM FactScores FS
JOIN dimStudent ST ON FS.Student_ID = ST.Student_ID
JOIN dimSubject S ON FS.Subject_key = S.Subject_key
GROUP BY ST.Full_Name, S.Subject
ORDER BY ST.Full_Name, S.Subject;
