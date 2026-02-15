--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Row counts and size per table
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Table Row Counts and Sizes Report
-- Lists all user tables with row count, data size, and index size
-- Compatible with SQL Server 2016+

SELECT
    s.name AS [Schema],
    t.name AS [Table],
    p.rows AS [RowCount],
    CAST(SUM(a.total_pages) * 8.0 / 1024.0 AS DECIMAL(12,2)) AS [TotalSpaceMB],
    CAST(SUM(a.used_pages) * 8.0 / 1024.0 AS DECIMAL(12,2)) AS [UsedSpaceMB],
    CAST((SUM(a.total_pages) - SUM(a.used_pages)) * 8.0 / 1024.0 AS DECIMAL(12,2)) AS [UnusedSpaceMB],
    CAST(SUM(CASE WHEN a.type = 1 THEN a.used_pages ELSE 0 END) * 8.0 / 1024.0 AS DECIMAL(12,2)) AS [DataSizeMB],
    CAST(SUM(CASE WHEN a.type != 1 THEN a.used_pages ELSE 0 END) * 8.0 / 1024.0 AS DECIMAL(12,2)) AS [IndexSizeMB],
    COUNT(DISTINCT i.index_id) - 1 AS [IndexCount],  -- subtract clustered/heap
    t.create_date AS [Created],
    t.modify_date AS [LastModified]
FROM
    sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE
    t.is_ms_shipped = 0
    AND i.object_id > 255
GROUP BY
    s.name, t.name, p.rows, t.create_date, t.modify_date
ORDER BY
    SUM(a.total_pages) DESC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Row counts and size per table
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
