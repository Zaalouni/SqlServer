-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER -     Export Blob To file Sqlserver
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------


use master
go

EXEC sp_configure 'show advanced options', 1
GO

Reconfigure
go

EXEC sp_configure 'xp_cmdshell', 1
GO

Reconfigure
go


/*********** REMEMBER TO TURN OFF THE show 'advanced options' and 'xp_cmdshell' afterwards! ***********/

use MyDBName

-- SQL Server export image

DECLARE  @Command NVARCHAR(4000)

DECLARE @DBServer NVARCHAR(100) = 'localhost\sqlserver'

-- Keep the command on ONE SINGLE LINE
SET @Command = 'bcp "SELECT [file_field] FROM MyDBName.dbo.attachments where attachment_id = 123 " queryout "C:\temp\testfile.pdf" -T -n -S'+@DBServer

-- This will export the file, but the file will appear corrupted if you try and open it. 
-- This is because the first 16 bytes are used to indicate the length of the file (they're a 
-- left-over from the SQL database binary stream), the bcp command doesn't strip them off.
-- Delete those first 16 bytes using a hex editor (or even Notepad++), save the file, and you 
-- should then be able to open it.

PRINT @Command -- debugging

EXEC xp_cmdshell @Command

GO

/*********** TURN ON THE show advanced options and xp_cmdshell afterwards, but do it in reverse :) ***********/

use master
go

EXEC sp_configure 'xp_cmdshell', 0
GO

Reconfigure
go

EXEC sp_configure 'show advanced options', 0
GO

Reconfigure
go