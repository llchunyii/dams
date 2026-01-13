USE DAMS;

DECLARE @AuditFilePath VARCHAR (1000);
SET @AuditFilePath = 'C:\MSSQL\MSSQL_Audit\Audit-20251223-225649_FDD28155-374F-4DD8-B082-0B8E6678B391_0_134110302755840000.sqlaudit';


--SELECT @AuditFilePath = 'C:\MSSQL\MSSQL_Audit\Audit-20251223-225649_FDD28155-374F-4DD8-B082-0B8E6678B391_0_134109761450140000.sqlaudit'
--FROM sys.dm_server_audit_status

select *
from sys.fn_get_audit_file(@AuditFilePath,default,default)


SELECT
    event_time,
    action_id,
    server_principal_name,
    database_name,
    schema_name,
    object_name,
    statement
FROM sys.fn_get_audit_file(
    @AuditFilePath,
    DEFAULT,
    DEFAULT
)
ORDER BY event_time DESC;


SELECT
    das.name AS audit_spec_name,
    dsa.audit_action_name,
    dsa.class_desc,
    dsa.audited_principal_id
FROM sys.database_audit_specifications AS das
JOIN sys.database_audit_specification_details AS dsa
    ON das.database_specification_id = dsa.database_specification_id;


   SELECT SYSTEM_USER AS login, USER_NAME() AS db_user;
