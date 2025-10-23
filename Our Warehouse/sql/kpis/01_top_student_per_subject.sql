-- 01_top_student_per_subject.sql
-- Top student per subject
SELECT
    s.Subject AS [Subject],
    st.Full_Name AS [Top Student],
    f.Score AS [Score]
FROM FactScores f
JOIN dimSubject s ON f.Subject_key = s.Subject_key
JOIN dimStudent st ON f.Student_ID = st.Student_ID
WHERE f.Score = (
    SELECT MAX(f2.Score)
    FROM FactScores f2
    WHERE f2.Subject_key = f.Subject_key
)
ORDER BY s.Subject;
