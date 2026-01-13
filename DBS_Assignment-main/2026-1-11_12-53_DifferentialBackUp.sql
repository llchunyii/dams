USE msdb;
GO

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'DAMS_Diff_Backup_6Hours')
BEGIN
    EXEC msdb.dbo.sp_delete_job
        @job_name = N'DAMS_Diff_Backup_6Hours',
        @delete_unused_schedule = 1;
END
GO

DECLARE @CurrentLogin SYSNAME;
DECLARE @StartDate INT;
DECLARE @ScheduleID INT;

SET @CurrentLogin = SUSER_SNAME();
SET @StartDate = CAST(CONVERT(VARCHAR(8), GETDATE(), 112) AS INT);

EXEC msdb.dbo.sp_add_job
    @job_name = N'DAMS_Diff_Backup_6Hours',
    @enabled = 1,
    @description = N'Differential backup of DAMS every 6 hours',
    @owner_login_name = @CurrentLogin;

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'DAMS_Diff_Backup_6Hours',
    @step_name = N'Differential Backup Step',
    @subsystem = N'TSQL',
    @database_name = N'master',
    @command = N'
DECLARE @FileName NVARCHAR(400);

SET @FileName =
    ''C:\DAMS_Backups\DIFFERENTIAL\DAMS_Diff_'' +
    CONVERT(VARCHAR(8), GETDATE(), 112) + ''_'' +
    REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), '':'', '''') + ''.bak'';

BACKUP DATABASE DAMS
TO DISK = @FileName
WITH DIFFERENTIAL, INIT, CHECKSUM;
',
    @on_success_action = 1,
    @on_fail_action = 2;

EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'DAMS_Diff_6Hours_Schedule',
    @enabled = 1,
    @freq_type = 4,          
    @freq_interval = 1,
    @freq_subday_type = 8,     
    @freq_subday_interval = 6, 
    @active_start_date = @StartDate,
    @active_start_time = 000000,
    @schedule_id = @ScheduleID OUTPUT;


EXEC msdb.dbo.sp_attach_schedule
    @job_name = N'DAMS_Diff_Backup_6Hours',
    @schedule_id = @ScheduleID;

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'DAMS_Diff_Backup_6Hours';
GO
