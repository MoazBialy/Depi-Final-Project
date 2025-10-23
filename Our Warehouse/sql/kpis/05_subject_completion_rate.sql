-- 05_subject_completion_rate.sql
-- Percentage of students per subject with >= 5 recorded scores
WITH SubjectTotalScores AS (
    SELECT
        Subject_key,
        Student_ID,
        COUNT(Score) AS RecordedScores
    FROM FactScores
    GROUP BY Subject_key, Student_ID
)
SELECT
    S.Subject,
    SUM(CASE WHEN STS.RecordedScores >= 5 THEN 1 ELSE 0 END) AS CompletedStudents,
    COUNT(STS.Student_ID) AS TotalStudents,
    SUM(CASE WHEN STS.RecordedScores >= 5 THEN 1 ELSE 0 END) * 100.0 / COUNT(STS.Student_ID) AS CompletionRate_Percent
FROM SubjectTotalScores STS
JOIN dimSubject S ON STS.Subject_key = S.Subject_key
GROUP BY S.Subject;
