--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Last backup per database with size and duration
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Backup History Report
-- Shows last FULL, DIFF, and LOG backup for each database
-- Compatible with SQL Server 2016+

SELECT
    d.name AS [Database],
    d.recovery_model_desc AS [RecoveryModel],
    bs.type AS [BackupType],
    CASE bs.type
        WHEN 'D' THEN 'FULL'
        WHEN 'I' THEN 'DIFFERENTIAL'
        WHEN 'L' THEN 'LOG'
        ELSE bs.type
    END AS [BackupTypeDesc],
    bs.backup_start_date AS [StartTime],
    bs.backup_finish_date AS [EndTime],
    DATEDIFF(SECOND, bs.backup_start_date, bs.backup_finish_date) AS [DurationSeconds],
    CAST(bs.backup_size / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS [BackupSizeMB],
    CAST(bs.compressed_backup_size / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS [CompressedSizeMB],
    CAST(100.0 - (bs.compressed_backup_size * 100.0 / NULLIF(bs.backup_size, 0)) AS DECIMAL(5,1)) AS [CompressionRatio%],
    bmf.physical_device_name AS [BackupPath],
    bs.user_name AS [BackupBy],
    DATEDIFF(HOUR, bs.backup_finish_date, GETDATE()) AS [HoursSinceBackup]
FROM
    sys.databases d
    LEFT JOIN (
        SELECT
            database_name,
            type,
            backup_start_date,
            backup_finish_date,
            backup_size,
            compressed_backup_size,
            user_name,
            media_set_id,
            ROW_NUMBER() OVER (PARTITION BY database_name, type ORDER BY backup_finish_date DESC) AS rn
        FROM msdb.dbo.backupset
    ) bs ON d.name = bs.database_name AND bs.rn = 1
    LEFT JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
WHERE
    d.database_id > 4  -- exclude system databases
ORDER BY
    d.name, bs.type;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Last backup per database with size and duration
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
