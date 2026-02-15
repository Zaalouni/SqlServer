--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Monitor restore operations in progress
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Restore Progress Monitor
-- Tracks active RESTORE operations with estimated completion time
-- Compatible with SQL Server 2016+

SELECT
    r.session_id AS [SessionID],
    r.command AS [Command],
    r.percent_complete AS [PercentComplete],
    CAST(r.percent_complete AS DECIMAL(5,2)) AS [Progress%],
    r.start_time AS [StartTime],
    DATEADD(MILLISECOND, r.estimated_completion_time, GETDATE()) AS [EstimatedEndTime],
    CAST(r.estimated_completion_time / 1000.0 / 60.0 AS DECIMAL(10,1)) AS [EstimatedMinutesRemaining],
    CAST(DATEDIFF(SECOND, r.start_time, GETDATE()) / 60.0 AS DECIMAL(10,1)) AS [ElapsedMinutes],
    r.status AS [Status],
    DB_NAME(r.database_id) AS [Database],
    t.text AS [SqlText],
    r.blocking_session_id AS [BlockedBy],
    r.wait_type AS [WaitType],
    r.last_wait_type AS [LastWaitType]
FROM
    sys.dm_exec_requests r
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE
    r.command IN ('RESTORE DATABASE', 'RESTORE LOG', 'RESTORE HEADERONLY', 'RESTORE FILELISTONLY')
ORDER BY
    r.percent_complete DESC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Monitor restore operations in progress
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
