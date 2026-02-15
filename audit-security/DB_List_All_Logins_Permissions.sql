--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - List all logins and server-level permissions
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------

-- All Logins and Permissions Report
-- Lists server principals with their roles and explicit permissions
-- Compatible with SQL Server 2016+

-- Part 1: All server logins with type and status
SELECT
    sp.name AS [Login],
    sp.type_desc AS [LoginType],
    sp.create_date AS [Created],
    sp.modify_date AS [Modified],
    sp.is_disabled AS [IsDisabled],
    sp.default_database_name AS [DefaultDB],
    sl.is_policy_checked AS [PasswordPolicyEnforced],
    sl.is_expiration_checked AS [PasswordExpirationEnabled]
FROM
    sys.server_principals sp
    LEFT JOIN sys.sql_logins sl ON sp.principal_id = sl.principal_id
WHERE
    sp.type IN ('S', 'U', 'G')  -- SQL Login, Windows Login, Windows Group
ORDER BY
    sp.type_desc, sp.name;

-- Part 2: Server role memberships
SELECT
    member.name AS [Login],
    member.type_desc AS [LoginType],
    role.name AS [ServerRole]
FROM
    sys.server_role_members srm
    INNER JOIN sys.server_principals role ON srm.role_principal_id = role.principal_id
    INNER JOIN sys.server_principals member ON srm.member_principal_id = member.principal_id
ORDER BY
    role.name, member.name;

-- Part 3: Explicit server-level permissions
SELECT
    pr.name AS [Login],
    pr.type_desc AS [LoginType],
    pe.permission_name AS [Permission],
    pe.state_desc AS [State],
    pe.class_desc AS [Class]
FROM
    sys.server_permissions pe
    INNER JOIN sys.server_principals pr ON pe.grantee_principal_id = pr.principal_id
WHERE
    pr.type IN ('S', 'U', 'G', 'R')
ORDER BY
    pr.name, pe.permission_name;

--------------------------------------------------------------------------------------
-- File Name    : https://github.com/Zaalouni/SqlServer
-- Author       : Zaalouni
-- Description  : SQL SERVER - List all logins and server-level permissions
-- website      : http://www.aws-senior.com
-- Github       : https://github.com/Zaalouni/SqlServer
-- -----------------------------------------------------------------------------------
