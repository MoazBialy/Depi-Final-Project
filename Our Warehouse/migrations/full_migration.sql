-- full_migration.sql
-- Idempotent full migration for SQL Server to create schema and load CSV data
-- Generated: 2025-11-15
-- NOTES:
--  * Adjust the CSV file paths below if SQL Server cannot read the repository-relative paths.
--  * Run this script in SQL Server Management Studio (SSMS) or with sqlcmd on a server that can access the CSV files.

-- 1) Create database if not exists and switch to it
IF DB_ID(N'OurWarehouse') IS NULL
BEGIN
    PRINT N'Creating database OurWarehouse...';
    CREATE DATABASE OurWarehouse;
END
GO

USE OurWarehouse;
GO

SET XACT_ABORT ON;

--------------------------------------------------------------------------------
-- 2) Create dimension tables (idempotent)
--------------------------------------------------------------------------------

-- dimStudent
IF OBJECT_ID(N'dbo.dimStudent', N'U') IS NULL
BEGIN
    PRINT N'Creating table dbo.dimStudent...';
    CREATE TABLE dbo.dimStudent
    (
        Student_ID INT NOT NULL PRIMARY KEY,
        Full_Name NVARCHAR(255) NULL,
        Grade_Level INT NULL
    );
END
GO

-- dimSubject
IF OBJECT_ID(N'dbo.dimSubject', N'U') IS NULL
BEGIN
    PRINT N'Creating table dbo.dimSubject...';
    CREATE TABLE dbo.dimSubject
    (
        Subject_key INT NOT NULL PRIMARY KEY,
        Subject NVARCHAR(200) NULL
    );
END
GO

-- dim_score_type
IF OBJECT_ID(N'dbo.dim_score_type', N'U') IS NULL
BEGIN
    PRINT N'Creating table dbo.dim_score_type...';
    CREATE TABLE dbo.dim_score_type
    (
        ScoreTypeKey INT NOT NULL PRIMARY KEY,
        ScoreType NVARCHAR(100) NULL
    );
END
GO

-- dimAttendanceStatus
IF OBJECT_ID(N'dbo.dimAttendanceStatus', N'U') IS NULL
BEGIN
    PRINT N'Creating table dbo.dimAttendanceStatus...';
    CREATE TABLE dbo.dimAttendanceStatus
    (
        Attendance_Status_key INT NOT NULL PRIMARY KEY,
        Attendance_Status NVARCHAR(100) NULL
    );
END
GO

-- dim_date
IF OBJECT_ID(N'dbo.dim_date', N'U') IS NULL
BEGIN
    PRINT N'Creating table dbo.dim_date...';
    CREATE TABLE dbo.dim_date
    (
        DateKey INT NOT NULL PRIMARY KEY,
        FullDate DATE NULL,
        [Year] INT NULL,
        [Month] INT NULL,
        DayOfMonth INT NULL,
        DayName NVARCHAR(50) NULL,
        MonthName NVARCHAR(50) NULL,
        Quarter INT NULL
    );
END
GO

--------------------------------------------------------------------------------
-- 3) Create fact tables (idempotent) WITHOUT foreign key constraints (will apply later)
--------------------------------------------------------------------------------

-- FactAttendance
IF OBJECT_ID(N'dbo.FactAttendance', N'U') IS NULL
BEGIN
    PRINT N'Creating table dbo.FactAttendance...';
    CREATE TABLE dbo.FactAttendance
    (
        Student_ID INT NOT NULL,
        DateKey INT NOT NULL,
        Subject_key INT NOT NULL,
        Attendance_Status_key INT NOT NULL
    );
END
GO

-- FactScores
IF OBJECT_ID(N'dbo.FactScores', N'U') IS NULL
BEGIN
    PRINT N'Creating table dbo.FactScores...';
    CREATE TABLE dbo.FactScores
    (
        Student_ID INT NOT NULL,
        Subject_key INT NOT NULL,
        ScoreTypeKey INT NOT NULL,
        Score DECIMAL(5,2) NULL,
        DateKey INT NOT NULL
    );
END
GO

--------------------------------------------------------------------------------
-- 4) Load data from CSVs into dims, then facts (TRUNCATE then BULK INSERT for idempotency)
-- IMPORTANT: update the file paths below to absolute paths if SQL Server cannot access repo-relative paths
--------------------------------------------------------------------------------

PRINT N'Loading data into dimensions and facts...';

-- dimStudent
BEGIN TRY
    TRUNCATE TABLE dbo.dimStudent;
END TRY
BEGIN CATCH
    DELETE FROM dbo.dimStudent;
END CATCH;

BULK INSERT dbo.dimStudent
FROM 'Our Warehouse\\DimStudent.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\\n',
    CODEPAGE = '65001',
    TABLOCK
);
PRINT N'dimStudent load complete.';
GO

-- dimSubject
BEGIN TRY
    TRUNCATE TABLE dbo.dimSubject;
END TRY
BEGIN CATCH
    DELETE FROM dbo.dimSubject;
END CATCH;

BULK INSERT dbo.dimSubject
FROM 'Our Warehouse\\DimSubject.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\\n',
    CODEPAGE = '65001',
    TABLOCK
);
PRINT N'dimSubject load complete.';
GO

-- dim_score_type
BEGIN TRY
    TRUNCATE TABLE dbo.dim_score_type;
END TRY
BEGIN CATCH
    DELETE FROM dbo.dim_score_type;
END CATCH;

BULK INSERT dbo.dim_score_type
FROM 'Our Warehouse\\dim_score_type.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\\n',
    CODEPAGE = '65001',
    TABLOCK
);
PRINT N'dim_score_type load complete.';
GO

-- dimAttendanceStatus
BEGIN TRY
    TRUNCATE TABLE dbo.dimAttendanceStatus;
END TRY
BEGIN CATCH
    DELETE FROM dbo.dimAttendanceStatus;
END CATCH;

BULK INSERT dbo.dimAttendanceStatus
FROM 'Our Warehouse\\DimAttendanceStatus.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\\n',
    CODEPAGE = '65001',
    TABLOCK
);
PRINT N'dimAttendanceStatus load complete.';
GO

-- dim_date
BEGIN TRY
    TRUNCATE TABLE dbo.dim_date;
END TRY
BEGIN CATCH
    DELETE FROM dbo.dim_date;
END CATCH;

BULK INSERT dbo.dim_date
FROM 'Our Warehouse\\dim_date.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\\n',
    CODEPAGE = '65001',
    TABLOCK
);
PRINT N'dim_date load complete.';
GO

-- FactAttendance
BEGIN TRY
    TRUNCATE TABLE dbo.FactAttendance;
END TRY
BEGIN CATCH
    DELETE FROM dbo.FactAttendance;
END CATCH;

BULK INSERT dbo.FactAttendance
FROM 'Our Warehouse\\FactAttendance.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\\n',
    CODEPAGE = '65001',
    TABLOCK
);
PRINT N'FactAttendance load complete.';
GO

-- FactScores
BEGIN TRY
    TRUNCATE TABLE dbo.FactScores;
END TRY
BEGIN CATCH
    DELETE FROM dbo.FactScores;
END CATCH;

BULK INSERT dbo.FactScores
FROM 'Our Warehouse\\FactScores.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\\n',
    CODEPAGE = '65001',
    TABLOCK
);
PRINT N'FactScores load complete.';
GO

--------------------------------------------------------------------------------
-- 5) Apply constraints (from existing alter migration)
--------------------------------------------------------------------------------

SET XACT_ABORT ON;
BEGIN TRAN;

-- FactAttendance constraints
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_FactAttendance')
BEGIN
    ALTER TABLE dbo.FactAttendance
    ADD CONSTRAINT PK_FactAttendance PRIMARY KEY (Student_ID, Subject_key, DateKey, Attendance_Status_key);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactAttendance_Student')
BEGIN
    ALTER TABLE dbo.FactAttendance
    ADD CONSTRAINT FK_FactAttendance_Student
    FOREIGN KEY (Student_ID) REFERENCES dbo.dimStudent(Student_ID);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactAttendance_Subject')
BEGIN
    ALTER TABLE dbo.FactAttendance
    ADD CONSTRAINT FK_FactAttendance_Subject
    FOREIGN KEY (Subject_key) REFERENCES dbo.dimSubject(Subject_key);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactAttendance_Date')
BEGIN
    ALTER TABLE dbo.FactAttendance
    ADD CONSTRAINT FK_FactAttendance_Date
    FOREIGN KEY (DateKey) REFERENCES dbo.dim_date(DateKey);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactAttendance_Status')
BEGIN
    ALTER TABLE dbo.FactAttendance
    ADD CONSTRAINT FK_FactAttendance_Status
    FOREIGN KEY (Attendance_Status_key) REFERENCES dbo.dimAttendanceStatus(Attendance_Status_key);
END
GO

-- FactScores constraints
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_FactScores')
BEGIN
    ALTER TABLE dbo.FactScores
    ADD CONSTRAINT PK_FactScores PRIMARY KEY (Student_ID, Subject_key, DateKey, ScoreTypeKey);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactScores_Student')
BEGIN
    ALTER TABLE dbo.FactScores
    ADD CONSTRAINT FK_FactScores_Student
    FOREIGN KEY (Student_ID) REFERENCES dbo.dimStudent(Student_ID);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactScores_Subject')
BEGIN
    ALTER TABLE dbo.FactScores
    ADD CONSTRAINT FK_FactScores_Subject
    FOREIGN KEY (Subject_key) REFERENCES dbo.dimSubject(Subject_key);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactScores_Date')
BEGIN
    ALTER TABLE dbo.FactScores
    ADD CONSTRAINT FK_FactScores_Date
    FOREIGN KEY (DateKey) REFERENCES dbo.dim_date(DateKey);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactScores_Scoret')
BEGIN
    ALTER TABLE dbo.FactScores
    ADD CONSTRAINT FK_FactScores_Scoret
    FOREIGN KEY (ScoreTypeKey) REFERENCES dbo.dim_score_type(ScoreTypeKey);
END
GO

COMMIT;
GO

--------------------------------------------------------------------------------
-- 6) Optional helpful indexes
--------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactAttendance_Student' AND object_id = OBJECT_ID('dbo.FactAttendance'))
BEGIN
    CREATE INDEX IX_FactAttendance_Student ON dbo.FactAttendance (Student_ID);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactAttendance_Date' AND object_id = OBJECT_ID('dbo.FactAttendance'))
BEGIN
    CREATE INDEX IX_FactAttendance_Date ON dbo.FactAttendance (DateKey);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactScores_Student' AND object_id = OBJECT_ID('dbo.FactScores'))
BEGIN
    CREATE INDEX IX_FactScores_Student ON dbo.FactScores (Student_ID);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactScores_Date' AND object_id = OBJECT_ID('dbo.FactScores'))
BEGIN
    CREATE INDEX IX_FactScores_Date ON dbo.FactScores (DateKey);
END
GO

PRINT N'Full migration complete. Verify data counts and adjust paths if necessary.';
GO

-- End of full_migration.sql
