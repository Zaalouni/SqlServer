--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Blocked sessions and blocking chains
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Blocked Sessions Report
-- Shows all blocked sessions with their blocking chains
-- Compatible with SQL Server 2016+

-- Part 1: Current blocked sessions with details
SELECT
    blocked.session_id AS [BlockedSessionID],
    blocked.blocking_session_id AS [BlockingSessionID],
    DB_NAME(blocked.database_id) AS [Database],
    blocked.status AS [BlockedStatus],
    blocked.wait_type AS [WaitType],
    blocked.wait_time / 1000 AS [WaitTime_s],
    blocked.wait_resource AS [WaitResource],
    blocked_text.text AS [BlockedQuery],
    blocker_text.text AS [BlockingQuery],
    blocked_session.login_name AS [BlockedLogin],
    blocked_session.host_name AS [BlockedHost],
    blocked_session.program_name AS [BlockedProgram],
    blocker_session.login_name AS [BlockerLogin],
    blocker_session.host_name AS [BlockerHost],
    blocker_session.program_name AS [BlockerProgram],
    blocked.start_time AS [BlockedQueryStart],
    blocker.start_time AS [BlockerQueryStart]
FROM
    sys.dm_exec_requests blocked
    INNER JOIN sys.dm_exec_sessions blocked_session
        ON blocked.session_id = blocked_session.session_id
    LEFT JOIN sys.dm_exec_requests blocker
        ON blocked.blocking_session_id = blocker.session_id
    LEFT JOIN sys.dm_exec_sessions blocker_session
        ON blocked.blocking_session_id = blocker_session.session_id
    CROSS APPLY sys.dm_exec_sql_text(blocked.sql_handle) blocked_text
    OUTER APPLY sys.dm_exec_sql_text(blocker.sql_handle) blocker_text
WHERE
    blocked.blocking_session_id > 0
ORDER BY
    blocked.wait_time DESC;

-- Part 2: Head blockers (sessions blocking others but not blocked themselves)
SELECT
    s.session_id AS [HeadBlockerSessionID],
    s.login_name AS [Login],
    s.host_name AS [Host],
    s.program_name AS [Program],
    s.status AS [Status],
    r.command AS [Command],
    DB_NAME(r.database_id) AS [Database],
    t.text AS [CurrentQuery],
    COUNT(blocked.session_id) AS [SessionsBlocked]
FROM
    sys.dm_exec_sessions s
    LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
    OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) t
    INNER JOIN sys.dm_exec_requests blocked ON s.session_id = blocked.blocking_session_id
WHERE
    s.session_id NOT IN (SELECT session_id FROM sys.dm_exec_requests WHERE blocking_session_id > 0)
GROUP BY
    s.session_id, s.login_name, s.host_name, s.program_name, s.status,
    r.command, r.database_id, t.text
ORDER BY
    COUNT(blocked.session_id) DESC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Blocked sessions and blocking chains
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
