--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Wait statistics analysis sorted by impact
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Wait Stats Analysis
-- Shows top wait types sorted by total wait time, excluding benign waits
-- Compatible with SQL Server 2016+

WITH WaitStats AS (
    SELECT
        wait_type,
        waiting_tasks_count,
        wait_time_ms,
        max_wait_time_ms,
        signal_wait_time_ms,
        wait_time_ms - signal_wait_time_ms AS resource_wait_time_ms,
        100.0 * wait_time_ms / NULLIF(SUM(wait_time_ms) OVER (), 0) AS [Percentage]
    FROM sys.dm_os_wait_stats
    WHERE wait_type NOT IN (
        -- Filter out benign/idle waits
        'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE',
        'SLEEP_TASK', 'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH',
        'WAITFOR', 'LOGMGR_QUEUE', 'CHECKPOINT_QUEUE',
        'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT',
        'BROKER_TO_FLUSH', 'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT',
        'CLR_AUTO_EVENT', 'DISPATCHER_QUEUE_SEMAPHORE',
        'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT',
        'XE_DISPATCHER_JOIN', 'BROKER_EVENTHANDLER',
        'TRACEWRITE', 'FT_IFTSHC_MUTEX', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
        'BROKER_RECEIVE_WAITFOR', 'ONDEMAND_TASK_QUEUE',
        'DBMIRROR_EVENTS_QUEUE', 'DBMIRRORING_CMD',
        'DIRTY_PAGE_POLL', 'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
        'SP_SERVER_DIAGNOSTICS_SLEEP', 'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP',
        'QDS_ASYNC_QUEUE', 'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
        'WAIT_XTP_OFFLINE_CKPT_NEW_LOG'
    )
    AND waiting_tasks_count > 0
)
SELECT TOP 30
    wait_type AS [WaitType],
    waiting_tasks_count AS [WaitCount],
    CAST(wait_time_ms / 1000.0 AS DECIMAL(12,1)) AS [TotalWait_s],
    CAST(resource_wait_time_ms / 1000.0 AS DECIMAL(12,1)) AS [ResourceWait_s],
    CAST(signal_wait_time_ms / 1000.0 AS DECIMAL(12,1)) AS [SignalWait_s],
    CAST(wait_time_ms / NULLIF(waiting_tasks_count, 0) AS DECIMAL(12,1)) AS [AvgWait_ms],
    CAST(Percentage AS DECIMAL(5,2)) AS [Percentage%],
    CAST(SUM(Percentage) OVER (ORDER BY wait_time_ms DESC) AS DECIMAL(5,2)) AS [RunningTotal%]
FROM WaitStats
ORDER BY
    wait_time_ms DESC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Wait statistics analysis sorted by impact
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
