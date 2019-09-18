--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER -  Which indexes are missing? 
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

SET NOCOUNT ON;

SELECT 
    avg_user_impact AS average_improvement_percentage, 
    avg_total_user_cost AS average_cost_of_query_without_missing_index, 
    'CREATE INDEX idx_' + [statement] +  
    ISNULL(equality_columns, '_') +
    ISNULL(inequality_columns, '_') + ' ON ' + [statement] + ' (' + ISNULL(equality_columns, ' ') + 
    ISNULL(inequality_columns, ' ') + ')' + ISNULL(' INCLUDE (' + included_columns + ')', '') AS     create_missing_index_command
FROM 
    sys.dm_db_missing_index_details a INNER JOIN sys.dm_db_missing_index_groups b
        ON a.index_handle = b.index_handle INNER JOIN sys.dm_db_missing_index_group_stats c
             ON b.index_group_handle = c.group_handle
WHERE 
    avg_user_impact > = 40


SET NOCOUNT OFF;
	   
	   
--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER -  Which indexes are missing? 
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------