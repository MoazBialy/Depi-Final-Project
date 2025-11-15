# DEPI Final Project: Students Performance Data Warehouse

![Data Warehouse Banner](assets/channels4_profile.jpg)

## Overview

This repository houses the final project for the DEPI (Data Engineering Professional Internship) graduation. It implements a robust data warehouse solution for school analytics, focusing on student performance, attendance, and key performance indicators (KPIs). The project uses a star schema design to enable efficient querying and reporting on educational data.

Key highlights:
- **Star Schema Architecture**: Centralized fact tables (e.g., FactAttendance, FactScores) surrounded by dimension tables (e.g., dimStudent, dimSubject, dim_date) for optimized analytics.
- **Data Sources**: Sample CSV files for dimensions and facts, simulating real school data.
- **Migrations and Setup**: SQL scripts for full schema creation, data loading, and idempotent migrations (supports SQL Server and PostgreSQL).
- **Analytics**: Pre-built KPI queries for insights like attendance rates, average scores, and trends over time.

This project demonstrates data engineering best practices, including ETL processes, database migrations, and analytical querying. It's designed to be reproducible on any local machine with minimal setup.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Features

- **Data Modeling**: Star schema with dimensions (students, subjects, score types, attendance statuses, dates) and facts (attendance records, scores).
- **Migration Scripts**: 
  - `full_migration.sql` for SQL Server: Creates database, tables, loads data from CSVs, and applies constraints/indexes.
  - `full_migration_pg.sql` for PostgreSQL: Equivalent script with idempotent operations to prevent duplicates on re-runs.
- **Data Loading**: Automated import from CSV files (e.g., DimStudent.csv, FactScores.csv) using BULK INSERT (SQL Server) or \copy (PostgreSQL).
- **KPIs and Queries**: SQL files in `Our Warehouse/sql/kpis/` for metrics like:
  - Average student scores by subject.
  - Attendance trends by date/quarter.
  - Top-performing students or subjects.
- **Idempotency**: Scripts are safe to run multiple times without creating duplicates or errors.
- **Portability**: Supports migration to different DBMS (SQL Server or PostgreSQL) with minimal adjustments.

## Tech Stack

- **Database**: Microsoft SQL Server (primary) or PostgreSQL (alternative).
- **Languages/Tools**: SQL for schema and queries; CSVs for sample data.
- **Environment**: Tested on local setups; compatible with tools like SSMS (SQL Server Management Studio) or psql/pgAdmin (PostgreSQL).
- **Other**: No additional frameworks required—pure SQL for simplicity and focus on data engineering principles.

## Prerequisites

- A local database server:
  - Microsoft SQL Server (Express edition is sufficient) or PostgreSQL (version 12+).
- Tools to run SQL scripts:
  - SSMS or sqlcmd for SQL Server.
  - psql or pgAdmin for PostgreSQL.
- Access to the CSV files (cloned from this repo).
- Basic knowledge of SQL and database concepts.

## Installation and Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/MoazBialy/Depi-Final-Project.git
   cd Depi-Final-Project
   ```

2. **Set Up the Database**:
   - For **SQL Server**:
     - Open SSMS and connect to your local server.
     - Run `Our Warehouse/full_migration.sql`.
     - Note: Update CSV paths in the script to absolute paths (e.g., 'C:\\path\\to\\repo\\Our Warehouse\\DimStudent.csv') if relative paths don't work.
   - For **PostgreSQL**:
     - Ensure psql is installed and connect to your server.
     - Run: `psql -U yourusername -h localhost -f "Our Warehouse/full_migration_pg.sql"`.
     - Update CSV paths to absolute paths accessible by psql.
   - The script will:
     - Create the `OurWarehouse` database (if it doesn't exist).
     - Build tables idempotently.
     - Load data from CSVs.
     - Apply foreign keys, primary keys, and indexes.

3. **Verify Setup**:
   - Query the database: `SELECT COUNT(*) FROM dimStudent;` to check data loading.
   - If issues arise (e.g., path errors), refer to script comments for adjustments.

## Usage

### Running Migrations
- Execute the full migration script as described above to set up the warehouse from scratch.
- For updates only: Use the original `alter_migration.sql` if you already have the base schema.

### Querying KPIs
- Navigate to `Our Warehouse/sql/kpis/`.
- Run individual .sql files in your database tool, e.g.:
  - `average_scores_by_subject.sql` for score analytics.
- Example output: Use these queries in reports or BI tools like Power BI/Tableau for visualization.

### Extending the Project
- Add more data: Update CSVs and re-run the migration script.
- Custom Queries: Build on the star schema for advanced analytics (e.g., year-over-year comparisons).

## Project Structure

```
Depi-Final-Project/
├── Our Warehouse/
│   ├── README.md               # Detailed notes on migrations, KPIs, and CSVs
│   ├── DimAttendanceStatus.csv # Sample dimension CSV
│   ├── DimStudent.csv          # ...
│   ├── DimSubject.csv          # ...
│   ├── FactAttendance.csv      # Sample fact CSV
│   ├── FactScores.csv          # ...
│   ├── dim_date.csv            # ...
│   ├── dim_score_type.csv      # ...
│   ├── alter_migration.sql     # Original alter script
│   ├── full_migration.sql      # Full SQL Server migration
│   ├── full_migration_pg.sql   # Full PostgreSQL migration
│   └── sql/
│       └── kpis/               # KPI query files (e.g., average_scores.sql)
└── README.md                   # This file
```

## Contributing

This is a graduation project, but contributions are welcome! To contribute:
1. Fork the repo.
2. Create a feature branch (`git checkout -b feature/YourFeature`).
3. Commit changes (`git commit -m 'Add YourFeature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a Pull Request.

Please ensure code follows SQL best practices and include tests for new queries.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. (Note: If no LICENSE file exists, consider adding one.)

## Acknowledgments

- **Maintainer**: Saifullah
- **Contributors**: Moaz Bialy (repo owner) and DEPI team members.
- **Inspiration**: Built as part of the DEPI program for hands-on data engineering experience.
- Special thanks to instructors and peers for guidance.

For questions about this repository or to request additional materials (presentation slides, detailed methodology, or raw data), contact the maintainer: Saifullah.
