--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Databases without recent backup (alert)
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Databases Without Recent Backup
-- Flags databases with no FULL backup in the last 24 hours
-- Compatible with SQL Server 2016+

DECLARE @HoursThreshold INT = 24;  -- Adjust as needed

SELECT
    d.name AS [Database],
    d.state_desc AS [State],
    d.recovery_model_desc AS [RecoveryModel],
    d.create_date AS [Created],
    bs.LastFullBackup,
    bs.LastDiffBackup,
    bs.LastLogBackup,
    DATEDIFF(HOUR, bs.LastFullBackup, GETDATE()) AS [HoursSinceFullBackup],
    CASE
        WHEN bs.LastFullBackup IS NULL THEN 'NEVER BACKED UP'
        WHEN DATEDIFF(HOUR, bs.LastFullBackup, GETDATE()) > @HoursThreshold THEN 'OVERDUE'
        ELSE 'OK'
    END AS [Status]
FROM
    sys.databases d
    LEFT JOIN (
        SELECT
            database_name,
            MAX(CASE WHEN type = 'D' THEN backup_finish_date END) AS LastFullBackup,
            MAX(CASE WHEN type = 'I' THEN backup_finish_date END) AS LastDiffBackup,
            MAX(CASE WHEN type = 'L' THEN backup_finish_date END) AS LastLogBackup
        FROM msdb.dbo.backupset
        GROUP BY database_name
    ) bs ON d.name = bs.database_name
WHERE
    d.database_id > 4  -- exclude system databases
    AND d.state = 0     -- ONLINE only
    AND (bs.LastFullBackup IS NULL OR DATEDIFF(HOUR, bs.LastFullBackup, GETDATE()) > @HoursThreshold)
ORDER BY
    ISNULL(bs.LastFullBackup, '1900-01-01') ASC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Databases without recent backup (alert)
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
