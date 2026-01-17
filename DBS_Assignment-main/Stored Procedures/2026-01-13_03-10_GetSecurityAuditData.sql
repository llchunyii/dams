USE master;
GO


CREATE OR ALTER PROCEDURE GetSecurityAuditData
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @UserName NVARCHAR(128) = NULL,
    @ActionId VARCHAR(50) = NULL,
    @DatabaseName NVARCHAR(128) = NULL,
    @SucceededOnly BIT = NULL,
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
            database_principal_name,
            target_server_principal_name,
            target_database_principal_name,
            object_name,
            statement,
            additional_information,
            file_name,
            audit_file_offset
        FROM sys.fn_get_audit_file('C:\DAMS_Audit\Security\*.sqlaudit', DEFAULT, DEFAULT)
        WHERE event_time BETWEEN @StartDate AND @EndDate
            AND (@UserName IS NULL OR server_principal_name = @UserName)
            AND (@ActionId IS NULL OR action_id = @ActionId)
            AND (@DatabaseName IS NULL OR database_name = @DatabaseName)
            AND (@SucceededOnly IS NULL OR succeeded = @SucceededOnly)
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
