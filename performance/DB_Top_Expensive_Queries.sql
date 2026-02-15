--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Top 20 most expensive queries by CPU and IO
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Top Expensive Queries
-- Returns the top 20 queries by total CPU time and logical reads
-- Compatible with SQL Server 2016+

SELECT TOP 20
    qs.total_worker_time / 1000 AS [TotalCPU_ms],
    qs.total_worker_time / NULLIF(qs.execution_count, 0) / 1000 AS [AvgCPU_ms],
    qs.total_logical_reads AS [TotalLogicalReads],
    qs.total_logical_reads / NULLIF(qs.execution_count, 0) AS [AvgLogicalReads],
    qs.total_logical_writes AS [TotalLogicalWrites],
    qs.total_elapsed_time / 1000 AS [TotalElapsed_ms],
    qs.total_elapsed_time / NULLIF(qs.execution_count, 0) / 1000 AS [AvgElapsed_ms],
    qs.execution_count AS [ExecutionCount],
    qs.creation_time AS [PlanCreated],
    qs.last_execution_time AS [LastExecution],
    DB_NAME(st.dbid) AS [Database],
    SUBSTRING(st.text,
        (qs.statement_start_offset / 2) + 1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
        END - qs.statement_start_offset) / 2) + 1
    ) AS [QueryText],
    qp.query_plan AS [QueryPlan]
FROM
    sys.dm_exec_query_stats qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
    CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY
    qs.total_worker_time DESC;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Top 20 most expensive queries by CPU and IO
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
