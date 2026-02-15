# SqlServer — DBA Utility Scripts

Collection of **26 T-SQL utility scripts** for SQL Server database administrators, organized by theme. All scripts are compatible with **SQL Server 2016+**.

## Structure

```
SqlServer/
├── index-management/       (7 scripts)
├── backup-monitoring/      (5 scripts)
├── performance/            (6 scripts)
├── audit-security/         (4 scripts)
└── database-inventory/     (4 scripts)
```

## Scripts

### index-management/ (7)

| Script | Description |
|--------|-------------|
| DB_Display_Missing_Indexes.sql | Detailed missing index report with CREATE INDEX commands |
| DB_Which_indexes_are_missing.sql | Quick missing indexes with impact > 40% |
| DB_List_all_indexes_for_all_tables.sql | List all indexes for all user tables |
| DB_REBUILD_REORGANIZE_Index.sql | Syntax reference for REBUILD and REORGANIZE |
| DB_Index_Fragmentation_Report.sql | Fragmentation report with rebuild/reorganize thresholds |
| DB_Unused_Indexes.sql | Indexes never used since last restart |
| DB_Duplicate_Indexes.sql | Duplicate and redundant indexes detection |

### backup-monitoring/ (5)

| Script | Description |
|--------|-------------|
| DB_How_long_SQL_Server_backup_going.sql | Duration of last backup for a database |
| DB_How_long_will_the_CheckDB_run.sql | Monitor CHECKDB progress and estimated completion |
| DB_Backup_History_Report.sql | Last backup per database with size and duration |
| DB_Restore_Progress_Monitor.sql | Track active RESTORE operations in progress |
| DB_Databases_Without_Recent_Backup.sql | Alert: databases without recent backup |

### performance/ (6)

| Script | Description |
|--------|-------------|
| DB_Query_SQL_Server_transactions.sql | Transaction rates per day/hour/minute |
| DB_Export_Blob_TO_File.sql | Export BLOB data to file using BCP |
| DB_Top_Expensive_Queries.sql | Top 20 queries by CPU and IO consumption |
| DB_Wait_Stats_Analysis.sql | Wait statistics sorted by impact |
| DB_Blocked_Sessions.sql | Blocked sessions and blocking chains |
| DB_TempDB_Usage.sql | TempDB space usage by session |

### audit-security/ (4)

| Script | Description |
|--------|-------------|
| DB_Who_dropped_that_table.sql | Track who dropped or altered tables (trace log) |
| DB_List_All_Logins_Permissions.sql | All logins and server-level permissions |
| DB_Failed_Login_Attempts.sql | Failed login attempts from error log |
| DB_Database_User_Roles.sql | Users and role memberships per database |

### database-inventory/ (4)

| Script | Description |
|--------|-------------|
| DB_Quick_count_all_SQL_Server_Object_Types.sql | Count of all object types in a database |
| DB_All_Databases_Size.sql | Size of all databases (data + log) |
| DB_Table_Row_Counts_Sizes.sql | Row counts and size per table |
| DB_SQL_Server_Instance_Info.sql | Instance version, edition, memory config |

## Prerequisites

- SQL Server 2016 or later
- Appropriate permissions (most scripts require VIEW SERVER STATE or sysadmin)
- Some scripts use DMVs that require the instance to have been running for meaningful data

## Usage

1. Open the script in SSMS (SQL Server Management Studio) or Azure Data Studio
2. Review and adjust parameters (database names, thresholds) as needed
3. Execute against your target instance

## Author

- **Author**: Zaalouni
- **Website**: [aws-senior.com](http://www.aws-senior.com)
- **GitHub**: [github.com/Zaalouni/SqlServer](https://github.com/Zaalouni/SqlServer)
