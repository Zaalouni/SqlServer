--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Failed login attempts from error log
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Failed Login Attempts Report
-- Reads SQL Server error log for login failures
-- Compatible with SQL Server 2016+
-- Note: Requires "Both failed and successful logins" audit level in server properties

-- Create temp table for error log entries
IF OBJECT_ID('tempdb..#ErrorLog') IS NOT NULL
    DROP TABLE #ErrorLog;

CREATE TABLE #ErrorLog (
    LogDate DATETIME,
    ProcessInfo NVARCHAR(50),
    [Text] NVARCHAR(MAX)
);

-- Read current error log (log number 0)
INSERT INTO #ErrorLog
EXEC sp_readerrorlog 0, 1, N'Login failed';

-- Display failed login attempts
SELECT
    LogDate AS [AttemptTime],
    [Text] AS [ErrorMessage],
    -- Extract login name from message
    CASE
        WHEN [Text] LIKE '%Login failed for user ''%'
        THEN SUBSTRING([Text],
            CHARINDEX('''', [Text]) + 1,
            CHARINDEX('''', [Text], CHARINDEX('''', [Text]) + 1) - CHARINDEX('''', [Text]) - 1)
        ELSE 'Unknown'
    END AS [LoginName],
    -- Extract client IP if available
    CASE
        WHEN [Text] LIKE '%CLIENT:%'
        THEN SUBSTRING([Text],
            CHARINDEX('[CLIENT: ', [Text]) + 9,
            CHARINDEX(']', [Text], CHARINDEX('[CLIENT: ', [Text])) - CHARINDEX('[CLIENT: ', [Text]) - 9)
        ELSE 'N/A'
    END AS [ClientIP]
FROM #ErrorLog
ORDER BY LogDate DESC;

-- Summary: count by login name
SELECT
    CASE
        WHEN [Text] LIKE '%Login failed for user ''%'
        THEN SUBSTRING([Text],
            CHARINDEX('''', [Text]) + 1,
            CHARINDEX('''', [Text], CHARINDEX('''', [Text]) + 1) - CHARINDEX('''', [Text]) - 1)
        ELSE 'Unknown'
    END AS [LoginName],
    COUNT(*) AS [FailedAttempts],
    MIN(LogDate) AS [FirstAttempt],
    MAX(LogDate) AS [LastAttempt]
FROM #ErrorLog
GROUP BY
    CASE
        WHEN [Text] LIKE '%Login failed for user ''%'
        THEN SUBSTRING([Text],
            CHARINDEX('''', [Text]) + 1,
            CHARINDEX('''', [Text], CHARINDEX('''', [Text]) + 1) - CHARINDEX('''', [Text]) - 1)
        ELSE 'Unknown'
    END
ORDER BY COUNT(*) DESC;

DROP TABLE #ErrorLog;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Failed login attempts from error log
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
