--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER -     List all indexes for all tables in a SQL Server database   
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

 USE AdventureWorks2012;

       SELECT
              DB_NAME() [Database],
              sc.name [Schema],
              o.name [Table],
              i.name [Index],
              i.type_desc [Index Type]
       FROM
              sys.indexes i INNER JOIN sys.objects o
                ON i.object_id = o.object_id INNER JOIN sys.schemas sc
                     ON o.schema_id = sc.schema_id
       WHERE
              i.name IS NOT NULL
              AND o.type = 'U'
       ORDER BY
              o.name, i.type


	   
	   
--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER -   List all indexes for all tables in a SQL Server database 
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------