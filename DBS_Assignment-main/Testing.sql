USE [DAMS];
GO

EXECUTE AS USER = 'John';
SELECT * FROM dbo.Feedback;
REVERT

SELECT * FROM dbo.Employee;

-- Check if the audit is enabled
SELECT name, is_state_enabled
FROM sys.server_audits


-- Check if the database audit specification is enabled
SELECT name, is_state_enabled
FROM sys.database_audit_specifications
