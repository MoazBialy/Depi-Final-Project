-- 11_score_disparity_by_assessment_type.sql
-- Disparity of average scores by assessment type per subject
WITH SubjectScoreTypes AS (
    SELECT
        Subject_key,
        ScoreTypeKey,
        AVG(Score) AS TypeAverageScore
    FROM FactScores
    GROUP BY Subject_key, ScoreTypeKey
)
SELECT
    S.Subject,
    MAX(SST.TypeAverageScore) AS Max_Type_Average,
    MIN(SST.TypeAverageScore) AS Min_Type_Average,
    (MAX(SST.TypeAverageScore) - MIN(SST.TypeAverageScore)) AS ScoreDisparity
FROM SubjectScoreTypes SST
JOIN dimSubject S ON SST.Subject_key = S.Subject_key
GROUP BY S.Subject
HAVING COUNT(DISTINCT SST.ScoreTypeKey) > 1
ORDER BY ScoreDisparity DESC;
