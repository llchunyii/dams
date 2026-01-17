USE master;
GO 

--------------- TDE ---------------

-- Create Certificate 
CREATE CERTIFICATE DAMS_TDE_Cert 
WITH SUBJECT = 'TDE Cert for DAMS';
GO 

-- Backup Certificate
BACKUP CERTIFICATE DAMS_TDE_Cert
	TO FILE = 'C:\DAMS_Encryption\DAMS_TDE_Cert.cer'
	WITH PRIVATE KEY (
		FILE = 'C:\DAMS_Encryption\DAMS_TDE_Cert_Key.pvk',
		ENCRYPTION BY PASSWORD = '123'
	);
GO

-- Create Database Encryption Key 
USE DAMS;
GO

CREATE DATABASE ENCRYPTION KEY 
WITH ALGORITHM = AES_256 
ENCRYPTION BY SERVER CERTIFICATE DAMS_TDE_Cert;
GO

/*check encryption key
SELECT *
FROM sys.dm_database_encryption_keys
WHERE database_id = DB_ID();
*/

-- Enable TDE
ALTER DATABASE DAMS SET ENCRYPTION ON;
GO

-- Verify TDE Status
SELECT 
    db.name AS DatabaseName,
    dek.encryption_state,
    CASE dek.encryption_state
        WHEN 3 THEN 'Encrypted'
        WHEN 2 THEN 'Encryption in progress'
        ELSE 'Not encrypted'
    END AS Status
FROM sys.dm_database_encryption_keys dek
INNER JOIN sys.databases db ON dek.database_id = db.database_id
WHERE db.name = 'DAMS';
GO

