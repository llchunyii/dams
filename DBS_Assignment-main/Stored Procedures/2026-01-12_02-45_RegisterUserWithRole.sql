USE DAMS;
GO

CREATE OR ALTER PROCEDURE RegisterUserWithRole
    @LoginName NVARCHAR(128),
    @Password NVARCHAR(128),
    @DatabaseUserName NVARCHAR(128) = NULL,
    @RoleName NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF @DatabaseUserName IS NULL
            SET @DatabaseUserName = @LoginName;

        IF NOT EXISTS (
            SELECT 1 
            FROM sys.database_principals 
            WHERE name = @RoleName AND type = 'R'
        )
        BEGIN
            RAISERROR('Database role "%s" does not exist.', 16, 1, @RoleName);
            RETURN;
        END

        DECLARE @SQL NVARCHAR(MAX);

        IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @LoginName)
        BEGIN
            SET @SQL = N'CREATE LOGIN ' + QUOTENAME(@LoginName) + 
                       N' WITH PASSWORD = ' + QUOTENAME(@Password, '''') + 
                       N', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;';
            EXEC sp_executesql @SQL;
        END


        IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @DatabaseUserName)
        BEGIN
            SET @SQL = N'CREATE USER ' + QUOTENAME(@DatabaseUserName) + 
                       N' FOR LOGIN ' + QUOTENAME(@LoginName) + N';';
            EXEC sp_executesql @SQL;
        END

        IF EXISTS (
            SELECT 1
            FROM sys.database_role_members rm
            JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
            JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
            WHERE r.name = @RoleName
              AND u.name = @DatabaseUserName
        )
        BEGIN
            SELECT
                @LoginName          AS LoginName,
                @DatabaseUserName   AS DatabaseUserName,
                @RoleName           AS RoleName,
                'User is already assigned to this role' AS Status,
                GETDATE()           AS CreatedAt;
            RETURN; 
        END

        SET @SQL = N'ALTER ROLE ' + QUOTENAME(@RoleName) + 
                   N' ADD MEMBER ' + QUOTENAME(@DatabaseUserName) + N';';
        EXEC sp_executesql @SQL;


        SELECT 
            @LoginName AS LoginName,
            @DatabaseUserName AS DatabaseUserName,
            @RoleName AS RoleName,
            'User registered and assigned to role successfully' AS Status,
            GETDATE() AS CreatedAt;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO