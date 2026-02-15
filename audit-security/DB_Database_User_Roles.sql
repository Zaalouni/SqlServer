--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Database users and role memberships per database
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- Database Users and Roles Report
-- Lists all users with their roles for the current database
-- Compatible with SQL Server 2016+
-- Run this script in the context of each database you want to audit

-- Part 1: Database users with their mapped logins
SELECT
    DB_NAME() AS [Database],
    dp.name AS [DatabaseUser],
    dp.type_desc AS [UserType],
    dp.create_date AS [Created],
    dp.default_schema_name AS [DefaultSchema],
    sp.name AS [ServerLogin],
    sp.type_desc AS [LoginType],
    dp.authentication_type_desc AS [AuthType]
FROM
    sys.database_principals dp
    LEFT JOIN sys.server_principals sp ON dp.sid = sp.sid
WHERE
    dp.type IN ('S', 'U', 'G', 'E', 'X')  -- SQL user, Windows user/group, External
    AND dp.name NOT IN ('dbo', 'guest', 'INFORMATION_SCHEMA', 'sys')
ORDER BY
    dp.name;

-- Part 2: Database role memberships
SELECT
    DB_NAME() AS [Database],
    member.name AS [DatabaseUser],
    member.type_desc AS [UserType],
    role.name AS [DatabaseRole]
FROM
    sys.database_role_members drm
    INNER JOIN sys.database_principals role ON drm.role_principal_id = role.principal_id
    INNER JOIN sys.database_principals member ON drm.member_principal_id = member.principal_id
WHERE
    member.name NOT IN ('dbo')
ORDER BY
    role.name, member.name;

-- Part 3: Explicit database-level permissions
SELECT
    DB_NAME() AS [Database],
    pr.name AS [DatabaseUser],
    pr.type_desc AS [UserType],
    pe.permission_name AS [Permission],
    pe.state_desc AS [State],
    pe.class_desc AS [Class],
    OBJECT_NAME(pe.major_id) AS [ObjectName]
FROM
    sys.database_permissions pe
    INNER JOIN sys.database_principals pr ON pe.grantee_principal_id = pr.principal_id
WHERE
    pr.name NOT IN ('dbo', 'guest', 'public', 'INFORMATION_SCHEMA', 'sys')
    AND pe.type != 'CO'  -- exclude CONNECT permission
ORDER BY
    pr.name, pe.permission_name;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - Database users and role memberships per database
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
