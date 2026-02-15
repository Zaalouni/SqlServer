--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - TempDB space usage by session
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- TempDB Usage Report
-- Shows TempDB space consumption per session and overall status
-- Compatible with SQL Server 2016+

-- Part 1: TempDB overall space usage
SELECT
    SUM(unallocated_extent_page_count) / 128.0 AS [FreeSpaceMB],
    SUM(internal_object_reserved_page_count) / 128.0 AS [InternalObjectsMB],
    SUM(user_object_reserved_page_count) / 128.0 AS [UserObjectsMB],
    SUM(version_store_reserved_page_count) / 128.0 AS [VersionStoreMB],
    SUM(mixed_extent_page_count) / 128.0 AS [MixedExtentsMB],
    SUM(total_page_count) / 128.0 AS [TotalSizeMB]
FROM
    sys.dm_db_file_space_usage;

-- Part 2: TempDB usage per session (top consumers)
SELECT TOP 20
    ts.session_id AS [SessionID],
    s.login_name AS [Login],
    s.host_name AS [Host],
    s.program_name AS [Program],
    DB_NAME(r.database_id) AS [Database],
    (ts.user_objects_alloc_page_count - ts.user_objects_dealloc_page_count) / 128.0 AS [UserObjectsMB],
    (ts.internal_objects_alloc_page_count - ts.internal_objects_dealloc_page_count) / 128.0 AS [InternalObjectsMB],
    ((ts.user_objects_alloc_page_count - ts.user_objects_dealloc_page_count) +
     (ts.internal_objects_alloc_page_count - ts.internal_objects_dealloc_page_count)) / 128.0 AS [TotalTempDBUsageMB],
    r.status AS [RequestStatus],
    r.command AS [Command],
    t.text AS [QueryText]
FROM
    sys.dm_db_session_space_usage ts
    INNER JOIN sys.dm_exec_sessions s ON ts.session_id = s.session_id
    LEFT JOIN sys.dm_exec_requests r ON ts.session_id = r.session_id
    OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE
    ts.session_id > 50  -- exclude system sessions
    AND ((ts.user_objects_alloc_page_count - ts.user_objects_dealloc_page_count) +
         (ts.internal_objects_alloc_page_count - ts.internal_objects_dealloc_page_count)) > 0
ORDER BY
    TotalTempDBUsageMB DESC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - TempDB space usage by session
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
