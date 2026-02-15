--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Find duplicate and redundant indexes
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Duplicate Indexes Report
-- Finds indexes with identical or overlapping key columns
-- Compatible with SQL Server 2016+

WITH IndexColumns AS (
    SELECT
        i.object_id,
        i.index_id,
        i.name AS IndexName,
        i.type_desc AS IndexType,
        i.is_unique,
        (SELECT STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal)
         FROM sys.index_columns ic
         INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
         WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0
        ) AS KeyColumns,
        (SELECT STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal)
         FROM sys.index_columns ic
         INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
         WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 1
        ) AS IncludedColumns
    FROM sys.indexes i
    WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1
      AND i.index_id > 0
      AND i.name IS NOT NULL
)
SELECT
    DB_NAME() AS [Database],
    OBJECT_SCHEMA_NAME(a.object_id) AS [Schema],
    OBJECT_NAME(a.object_id) AS [Table],
    a.IndexName AS [Index1],
    a.IndexType AS [Index1Type],
    b.IndexName AS [Index2],
    b.IndexType AS [Index2Type],
    a.KeyColumns AS [KeyColumns],
    a.IncludedColumns AS [IncludedColumns1],
    b.IncludedColumns AS [IncludedColumns2],
    CASE
        WHEN a.KeyColumns = b.KeyColumns AND ISNULL(a.IncludedColumns, '') = ISNULL(b.IncludedColumns, '')
        THEN 'EXACT DUPLICATE'
        ELSE 'OVERLAPPING KEYS'
    END AS [DuplicateType]
FROM IndexColumns a
INNER JOIN IndexColumns b
    ON a.object_id = b.object_id
    AND a.index_id < b.index_id
    AND a.KeyColumns = b.KeyColumns
ORDER BY
    OBJECT_NAME(a.object_id), a.IndexName;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Find duplicate and redundant indexes
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
