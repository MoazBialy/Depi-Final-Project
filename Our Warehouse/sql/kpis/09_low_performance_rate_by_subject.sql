-- 09_low_performance_rate_by_subject.sql
-- Count of low scores (<60) per subject
SELECT
    S.Subject,
    SUM(CASE WHEN FS.Score < 60 THEN 1 ELSE 0 END) AS LowScoresCount
FROM FactScores FS
JOIN dimSubject S ON FS.Subject_key = S.Subject_key
GROUP BY S.Subject
ORDER BY LowScoresCount DESC;
