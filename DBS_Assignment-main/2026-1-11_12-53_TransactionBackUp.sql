USE msdb;
GO

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'DAMS_Log_Backup_15min')
BEGIN
    EXEC msdb.dbo.sp_delete_job
        @job_name = N'DAMS_Log_Backup_15min',
        @delete_unused_schedule = 1;
END
GO

DECLARE @CurrentLogin SYSNAME;
DECLARE @StartDate INT;
DECLARE @ScheduleID INT;

SET @CurrentLogin = SUSER_SNAME();
SET @StartDate = CAST(CONVERT(VARCHAR(8), GETDATE(), 112) AS INT);

EXEC msdb.dbo.sp_add_job
    @job_name = N'DAMS_Log_Backup_15min',
    @enabled = 1,
    @description = N'Transaction log backup every 15 minutes for DAMS',
    @owner_login_name = @CurrentLogin;

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'DAMS_Log_Backup_15min',
    @step_name = N'Transaction Log Backup Step',
    @subsystem = N'TSQL',
    @database_name = N'master',
    @command = N'
DECLARE @FileName NVARCHAR(400);

SET @FileName =
    ''C:\DAMS_Backups\TRANSACTION\DAMS_Log_'' +
    CONVERT(VARCHAR(8), GETDATE(), 112) + ''_'' +
    REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), '':'', '''') + ''.trn'';

BACKUP LOG DAMS
TO DISK = @FileName
WITH INIT, CHECKSUM;
',
    @on_success_action = 1,
    @on_fail_action = 2;

EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'DAMS_Log_Backup_Schedule',
    @enabled = 1,
    @freq_type = 4,        
    @freq_interval = 1,
    @freq_subday_type = 4,  
    @freq_subday_interval = 15,
    @active_start_date = @StartDate,
    @active_start_time = 000000,
    @schedule_id = @ScheduleID OUTPUT;

EXEC msdb.dbo.sp_attach_schedule
    @job_name = N'DAMS_Log_Backup_15min',
    @schedule_id = @ScheduleID;

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'DAMS_Log_Backup_15min';
