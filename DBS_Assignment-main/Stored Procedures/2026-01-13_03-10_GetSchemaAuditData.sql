USE master;
GO


CREATE OR ALTER PROCEDURE GetSchemaAuditData
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @UserName NVARCHAR(128) = NULL,
    @SchemaName NVARCHAR(128) = NULL,
    @ObjectName NVARCHAR(128) = NULL,
    @TopRecords INT = 1000
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set default date range for last 7 days
    IF @StartDate IS NULL
        SET @StartDate = DATEADD(DAY, -7, GETDATE());
    
    IF @EndDate IS NULL
        SET @EndDate = GETDATE();

    BEGIN TRY
        SELECT TOP (@TopRecords)
            event_time,
            sequence_number,
            action_id,
            succeeded,
            session_id,
            server_principal_name,
            database_name,
            schema_name,
            object_name,
            statement,
            additional_information,
            file_name,
            audit_file_offset
        FROM sys.fn_get_audit_file('C:\DAMS_Audit\Schema\*.sqlaudit', DEFAULT, DEFAULT)
        WHERE event_time BETWEEN @StartDate AND @EndDate
            AND (@UserName IS NULL OR server_principal_name = @UserName)
            AND (@SchemaName IS NULL OR schema_name = @SchemaName)
            AND (@ObjectName IS NULL OR object_name LIKE '%' + @ObjectName + '%')
        ORDER BY event_time DESC;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState;
    END CATCH
END;
GO
