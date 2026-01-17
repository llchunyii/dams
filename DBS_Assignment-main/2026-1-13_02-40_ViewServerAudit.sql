USE DAMS;
GO

CREATE PROCEDURE ViewServerAuditLogs
	@LastHours INT = 24,
	@MinSeverity INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PathPattern NVARCHAR(500);
	SET @PathPattern = 'C:\SQLAuditLogs\*.sqlaudit';

	SELECT
		event_time,
		session_server_principal_name AS UserName,
		database_name,
		object_name,
		action_id,
		succeeded,
		server_principal_name,
		LEFT(statement,500) AS StatementPreview,
		file_name,
		sequence_number
	FROM sys.fn_get_audit_file (@PathPattern, DEFAULT, DEFAULT)
	WHERE event_time > DATEADD(HOUR, -@LastHours, GETDATE())
	ORDER BY event_time DESC;
END;
GO