/* Migration: 20251023_01_alter_constraints.sql
   Purpose: Apply primary keys and foreign key constraints for FactAttendance and FactScores
   Run this script in the target DB environment. Adjust or remove USE statement as needed.
   NOTE: Validate data integrity before applying (duplicates/orphan rows may cause failures).
*/
USE [SchoolWarehouseee];
GO

SET XACT_ABORT ON;
BEGIN TRAN;

-- FactAttendance constraints
ALTER TABLE FactAttendance
ADD CONSTRAINT PK_FactAttendance PRIMARY KEY (Student_ID, Subject_key, DateKey, Attendance_Status_key);
GO

ALTER TABLE FactAttendance
ADD CONSTRAINT FK_FactAttendance_Student
FOREIGN KEY (Student_ID) REFERENCES dimStudent(Student_ID);
GO

ALTER TABLE FactAttendance
ADD CONSTRAINT FK_FactAttendance_Subject
FOREIGN KEY (Subject_key) REFERENCES dimSubject(Subject_key);
GO

ALTER TABLE FactAttendance
ADD CONSTRAINT FK_FactAttendance_Date
FOREIGN KEY (DateKey) REFERENCES dim_date(DateKey);
GO

ALTER TABLE FactAttendance
ADD CONSTRAINT FK_FactAttendance_Status
FOREIGN KEY (Attendance_Status_key) REFERENCES dimAttendanceStatus(Attendance_Status_key);
GO

-- FactScores constraints
ALTER TABLE FactScores
ADD CONSTRAINT PK_FactScores PRIMARY KEY (Student_ID, Subject_key, DateKey, ScoreTypeKey);
GO

ALTER TABLE FactScores
ADD CONSTRAINT FK_FactScores_Student
FOREIGN KEY (Student_ID) REFERENCES dimStudent(Student_ID);
GO

ALTER TABLE FactScores
ADD CONSTRAINT FK_FactScores_Subject
FOREIGN KEY (Subject_key) REFERENCES dimSubject(Subject_key);
GO

ALTER TABLE FactScores
ADD CONSTRAINT FK_FactScores_Date
FOREIGN KEY (DateKey) REFERENCES dim_date(DateKey);
GO

ALTER TABLE FactScores
ADD CONSTRAINT FK_FactScores_Scoret
FOREIGN KEY (ScoreTypeKey) REFERENCES dim_score_type(ScoreTypeKey);
GO

COMMIT;
