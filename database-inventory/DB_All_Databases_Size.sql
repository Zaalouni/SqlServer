--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Size of all databases (data + log files)
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- All Databases Size Report
-- Shows data and log file sizes for every database on the instance
-- Compatible with SQL Server 2016+

SELECT
    d.name AS [Database],
    d.state_desc AS [State],
    d.recovery_model_desc AS [RecoveryModel],
    d.compatibility_level AS [CompatLevel],
    CAST(SUM(CASE WHEN mf.type = 0 THEN mf.size END) * 8.0 / 1024.0 AS DECIMAL(12,2)) AS [DataSizeMB],
    CAST(SUM(CASE WHEN mf.type = 1 THEN mf.size END) * 8.0 / 1024.0 AS DECIMAL(12,2)) AS [LogSizeMB],
    CAST(SUM(mf.size) * 8.0 / 1024.0 AS DECIMAL(12,2)) AS [TotalSizeMB],
    CAST(SUM(mf.size) * 8.0 / 1024.0 / 1024.0 AS DECIMAL(12,2)) AS [TotalSizeGB],
    d.create_date AS [Created]
FROM
    sys.databases d
    INNER JOIN sys.master_files mf ON d.database_id = mf.database_id
GROUP BY
    d.name, d.state_desc, d.recovery_model_desc, d.compatibility_level, d.create_date
ORDER BY
    SUM(mf.size) DESC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Size of all databases (data + log files)
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
