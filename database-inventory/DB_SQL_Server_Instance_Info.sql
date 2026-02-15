--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Instance information (version, edition, memory config)
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- SQL Server Instance Info
-- Displays key instance configuration and version details
-- Compatible with SQL Server 2016+

-- Part 1: Version and edition
SELECT
    SERVERPROPERTY('MachineName') AS [MachineName],
    SERVERPROPERTY('ServerName') AS [ServerName],
    SERVERPROPERTY('InstanceName') AS [InstanceName],
    SERVERPROPERTY('ProductVersion') AS [ProductVersion],
    SERVERPROPERTY('ProductLevel') AS [ProductLevel],
    SERVERPROPERTY('ProductUpdateLevel') AS [UpdateLevel],
    SERVERPROPERTY('Edition') AS [Edition],
    SERVERPROPERTY('EngineEdition') AS [EngineEdition],
    SERVERPROPERTY('Collation') AS [ServerCollation],
    SERVERPROPERTY('IsHadrEnabled') AS [AlwaysOnEnabled],
    SERVERPROPERTY('IsClustered') AS [IsClustered],
    SERVERPROPERTY('IsFullTextInstalled') AS [FullTextInstalled],
    @@VERSION AS [FullVersion];

-- Part 2: Memory configuration
SELECT
    name AS [Setting],
    value AS [ConfiguredValue],
    value_in_use AS [RunningValue],
    description AS [Description]
FROM
    sys.configurations
WHERE
    name IN (
        'max server memory (MB)',
        'min server memory (MB)',
        'max degree of parallelism',
        'cost threshold for parallelism',
        'optimize for ad hoc workloads',
        'max worker threads'
    )
ORDER BY
    name;

-- Part 3: Physical memory and CPU
SELECT
    cpu_count AS [LogicalCPUs],
    hyperthread_ratio AS [HyperthreadRatio],
    cpu_count / hyperthread_ratio AS [PhysicalCPUs],
    physical_memory_kb / 1024 AS [PhysicalMemoryMB],
    committed_kb / 1024 AS [CommittedMemoryMB],
    committed_target_kb / 1024 AS [TargetMemoryMB],
    sqlserver_start_time AS [LastRestart],
    DATEDIFF(DAY, sqlserver_start_time, GETDATE()) AS [UptimeDays]
FROM
    sys.dm_os_sys_info;

-- Part 4: Database count summary
SELECT
    COUNT(*) AS [TotalDatabases],
    SUM(CASE WHEN state = 0 THEN 1 ELSE 0 END) AS [Online],
    SUM(CASE WHEN state != 0 THEN 1 ELSE 0 END) AS [Offline/Other],
    SUM(CASE WHEN database_id <= 4 THEN 1 ELSE 0 END) AS [SystemDBs],
    SUM(CASE WHEN database_id > 4 THEN 1 ELSE 0 END) AS [UserDBs]
FROM
    sys.databases;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Instance information (version, edition, memory config)
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
