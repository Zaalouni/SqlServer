--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Index Fragmentation Report with rebuild/reorganize thresholds
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Index Fragmentation Report
-- Recommends REORGANIZE (5-30% fragmentation) or REBUILD (>30%)
-- Compatible with SQL Server 2016+

SELECT
    DB_NAME() AS [Database],
    OBJECT_SCHEMA_NAME(ips.object_id) AS [Schema],
    OBJECT_NAME(ips.object_id) AS [Table],
    i.name AS [Index],
    i.type_desc AS [IndexType],
    ips.avg_fragmentation_in_percent AS [Fragmentation%],
    ips.page_count AS [Pages],
    ips.avg_page_space_used_in_percent AS [PageDensity%],
    CASE
        WHEN ips.avg_fragmentation_in_percent > 30 THEN 'REBUILD'
        WHEN ips.avg_fragmentation_in_percent > 5  THEN 'REORGANIZE'
        ELSE 'OK'
    END AS [Recommendation],
    'ALTER INDEX [' + i.name + '] ON [' + OBJECT_SCHEMA_NAME(ips.object_id) + '].[' + OBJECT_NAME(ips.object_id) + '] ' +
    CASE
        WHEN ips.avg_fragmentation_in_percent > 30 THEN 'REBUILD WITH (ONLINE = ON);'
        WHEN ips.avg_fragmentation_in_percent > 5  THEN 'REORGANIZE;'
        ELSE '-- No action needed'
    END AS [Command]
FROM
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
    INNER JOIN sys.indexes i
        ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE
    ips.avg_fragmentation_in_percent > 5
    AND ips.page_count > 1000  -- ignore small indexes
    AND i.name IS NOT NULL
ORDER BY
    ips.avg_fragmentation_in_percent DESC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Index Fragmentation Report with rebuild/reorganize thresholds
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
