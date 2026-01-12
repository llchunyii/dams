USE master;
GO

--Create audit file for administrative audit
CREATE SERVER AUDIT DAMS_Administrative_Audit
TO FILE 
(
    FILEPATH = N'C:\DAMS_Audit\Administrative\',  
    MAXSIZE = 50 MB,
    MAX_ROLLOVER_FILES = 10,
    RESERVE_DISK_SPACE = OFF
)
WITH (QUEUE_DELAY = 2000, ON_FAILURE = CONTINUE);
GO

ALTER SERVER AUDIT DAMS_Administrative_Audit
WITH (STATE = ON);
GO

CREATE DATABASE AUDIT SPECIFICATION DAMS_Administrative_Audit_spec
FOR SERVER AUDIT DAMS_Administrative_Audit
ADD (BACKUP_RESTORE_GROUP)
WITH (STATE = ON);
GO