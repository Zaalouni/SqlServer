--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Find unused indexes since last SQL Server restart
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Unused Indexes Report
-- Lists indexes with zero seeks, scans, and lookups since last restart
-- Compatible with SQL Server 2016+

SELECT
    DB_NAME() AS [Database],
    OBJECT_SCHEMA_NAME(i.object_id) AS [Schema],
    OBJECT_NAME(i.object_id) AS [Table],
    i.name AS [Index],
    i.type_desc AS [IndexType],
    ISNULL(us.user_seeks, 0) AS [UserSeeks],
    ISNULL(us.user_scans, 0) AS [UserScans],
    ISNULL(us.user_lookups, 0) AS [UserLookups],
    ISNULL(us.user_updates, 0) AS [UserUpdates],
    p.rows AS [RowCount],
    (SELECT SUM(a.used_pages) * 8 / 1024.0
     FROM sys.partitions pt
     INNER JOIN sys.allocation_units a ON pt.hobt_id = a.container_id
     WHERE pt.object_id = i.object_id AND pt.index_id = i.index_id
    ) AS [IndexSizeMB],
    (SELECT create_date FROM sys.databases WHERE database_id = 2) AS [LastRestart],
    'DROP INDEX [' + i.name + '] ON [' + OBJECT_SCHEMA_NAME(i.object_id) + '].[' + OBJECT_NAME(i.object_id) + '];' AS [DropCommand]
FROM
    sys.indexes i
    LEFT JOIN sys.dm_db_index_usage_stats us
        ON i.object_id = us.object_id
        AND i.index_id = us.index_id
        AND us.database_id = DB_ID()
    INNER JOIN sys.partitions p
        ON i.object_id = p.object_id AND i.index_id = p.index_id
WHERE
    OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1
    AND i.type_desc = 'NONCLUSTERED'
    AND i.is_primary_key = 0
    AND i.is_unique_constraint = 0
    AND ISNULL(us.user_seeks, 0) = 0
    AND ISNULL(us.user_scans, 0) = 0
    AND ISNULL(us.user_lookups, 0) = 0
ORDER BY
    ISNULL(us.user_updates, 0) DESC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Find unused indexes since last SQL Server restart
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
