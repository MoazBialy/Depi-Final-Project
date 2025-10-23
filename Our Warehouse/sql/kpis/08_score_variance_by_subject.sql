-- 08_score_variance_by_subject.sql
-- Score variance and standard deviation per subject
SELECT
    S.Subject,
    AVG(FS.Score) AS AverageScore,
    STDEV(FS.Score) AS ScoreStandardDeviation,
    VAR(FS.Score) AS ScoreVariance
FROM FactScores FS
JOIN dimSubject S ON FS.Subject_key = S.Subject_key
GROUP BY S.Subject
ORDER BY ScoreStandardDeviation DESC;
