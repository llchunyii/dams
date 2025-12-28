USE master;
GO

DECLARE @FileName NVARCHAR(400);

SET @FileName =
    'C:\DAMS_Backups\FULL\DAMS_Full_' +
    CONVERT(VARCHAR(8), GETDATE(), 112) + '.bak';

BACKUP DATABASE DBS
TO DISK = @FileName
WITH INIT,
     NAME = 'Daily Full Backup of DAMS';
GO

USE master;
GO

DECLARE @FileName NVARCHAR(400);

SET @FileName =
    'C:\DAMS_Backups\DIFFERENTIAL\DAMS_Diff_' +
    CONVERT(VARCHAR(8), GETDATE(), 112) + '_' +
    REPLACE(CONVERT(VARCHAR(5), GETDATE(), 108), ':', '') +
    '.bak';

BACKUP DATABASE DBS
TO DISK = @FileName
WITH DIFFERENTIAL,
     INIT,
     NAME = 'Differential Backup of DAMS';
GO

USE master;
GO

DECLARE @FileName NVARCHAR(400);

SET @FileName =
    'C:\DAMS_Backups\TRANSACTION\DAMS_Log_' +
    CONVERT(VARCHAR(8), GETDATE(), 112) + '_' +
    REPLACE(CONVERT(VARCHAR(5), GETDATE(), 108), ':', '') +
    '.trn';

BACKUP LOG DBS
TO DISK = @FileName
WITH INIT,
     NAME = 'Transaction Log Backup of DAMS';
GO
