# SchoolWarehouseee — SQL assets

This folder contains SQL migrations and KPI queries for the SchoolWarehouseee project. The CSV data files are included for reference and testing.

Layout
- migrations/ : Timestamped DDL migration files. Run in order and validate first.
- sql/kpis/   : Individual KPI query files (one per KPI). Open and run the file you need.
- Querys and KPIs.sql : Index file listing available queries.
- *.csv : reference data files (do not commit large data exports)

Migration helper
- `full_migration.sql` — idempotent full migration script (creates DB, tables, loads CSVs, applies constraints). Run in SQL Server (adjust CSV paths if SQL Server cannot access repo-relative paths).

How to use
- Apply migrations: review files in `migrations/` and run using your migration tool or SQL client.
- Run KPIs: open the file under `sql/kpis/` and execute in SSMS / Azure Data Studio.

Notes
- Do NOT commit production credentials or large data dumps.
- Validate data integrity before applying constraints (duplicates/orphans will fail FK/PK additions).

Contact
- Maintainer: Saifullah
