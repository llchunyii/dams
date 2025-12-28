USE DAMS;
GO 
--------------- CLE ---------------
-- Create Master Key 
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'CLE_DAMS@123';
GO 

-- Create Certificate 
CREATE CERTIFICATE DAMS_CLE_Cert 
WITH SUBJECT = 'CLE Cert for DAMS';
GO 

-- Create Symmetric Key 
CREATE SYMMETRIC KEY DAMS_SymKey 
WITH ALGORITHM = AES_256 
ENCRYPTION BY CERTIFICATE DAMS_CLE_Cert;
GO

-- Add Encrypted Columns 
ALTER TABLE [User] ADD Email_Encrypted VARBINARY(MAX);
ALTER TABLE [User] ADD Phone_Encrypted VARBINARY(MAX);
ALTER TABLE [User] ADD Address_Encrypted VARBINARY(MAX);
GO

-- Encrypt Data
OPEN SYMMETRIC KEY DAMS_SymKey 
DECRYPTION BY CERTIFICATE DAMS_CLE_Cert;

UPDATE [User]
SET Email_Encrypted = ENCRYPTBYKEY(KEY_GUID('DAMS_SymKey'), Email);

UPDATE [User]
SET Phone_Encrypted = ENCRYPTBYKEY(KEY_GUID('DAMS_SymKey'), Phone);

UPDATE [User]
SET Address_Encrypted = ENCRYPTBYKEY(KEY_GUID('DAMS_SymKey'), Address);

CLOSE SYMMETRIC KEY DAMS_SymKey;
GO 

-- View Encrypted Data (Binary) 
SELECT TOP 3 
	UserID, 
	Username, 
	Email_Encrypted, 
	Phone_Encrypted, 
	Address_Encrypted 
FROM [User];
GO

/* Decrypt Data (only run this when u need to decrypt) 
OPEN SYMMETRIC KEY DAMS_SymKey 
DECRYPTION BY CERTIFICATE DAMS_CLE_Cert;

SELECT TOP 3
	UserID, 
	Username,
	CAST(DECRYPTBYKEY(Email_Encrypted) AS NVARCHAR(256)) AS Email,
	CAST(DECRYPTBYKEY(Phone_Encrypted) AS NVARCHAR(50)) AS Phone,
	CAST(DECRYPTBYKEY(Address_Encrypted) AS NVARCHAR(500)) AS Address
FROM [User];

CLOSE SYMMETRIC KEY DAMS_SymKey;
GO 
*/

-- Backup Certificate
BACKUP CERTIFICATE DAMS_CLE_Cert
	TO FILE = 'C:\DAMS_Encryption\DAMS_CLE_Cert.cer'
	WITH PRIVATE KEY (
		FILE = 'C:\DAMS_Encryption\DAMS_CLE_Cert_Key.pvk',
		ENCRYPTION BY PASSWORD = '123'
	);
GO