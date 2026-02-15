--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER -   How long will the CheckDB run? 
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

 SELECT 
          session_id,
          request_id,
          percent_complete,
          estimated_completion_time,
          DATEADD(ms,estimated_completion_time,GETDATE()) [EstimatedEndTime],
          estimated_completion_time/(1000*60) [EstimatedCompletionTimeInMinutes],
          start_time,
          status,
          command
       FROM
          sys.dm_exec_requests
       WHERE
          session_id = 65 --< this is the spid for your actively running checkdb


	   
	   
--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER -   How long will the CheckDB run?
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------