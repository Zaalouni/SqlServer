--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER -       Sql to take? 
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

 DECLARE @dbname sysname
SET @dbname = 'JDE_PRODUCTION' -- your dbname here
SELECT
  bup.user_name ByWhom,
  bup.database_name DatabaseName,
  bup.server_name ServerName,
  bup.backup_start_date StartTime,
  bup.backup_finish_date EndTime,
  CAST((CAST(DATEDIFF(s, bup.backup_start_date, bup.backup_finish_date) AS INT))/3600 AS VARCHAR) + ' hours, '
       + CAST((CAST(DATEDIFF(s, bup.backup_start_date, bup.backup_finish_date) AS INT))/60 AS VARCHAR)+ ' minutes, '
       + CAST((CAST(DATEDIFF(s, bup.backup_start_date, bup.backup_finish_date) AS INT))%60 AS VARCHAR)+ ' seconds' Duration
FROM msdb.dbo.backupset bup
WHERE bup.backup_set_id IN (
   SELECT MAX(backup_set_id)
   FROM msdb.dbo.backupset
   WHERE database_name = @dbname
   AND type = 'D' -- change for the type you need;  I = DIFF, L = LOG, D = FULL
   GROUP BY database_name
   );

	   
	   
--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER -    How long is that SQL Server backup going to take? 
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------