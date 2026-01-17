USE DAMS;
GO

CREATE SCHEMA UserPortalDevProc;

GO

ALTER SCHEMA UserPortalDevProc TRANSFER dbo.CreateNewAgent;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.CreateNewEmployee;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.CreateNewUser;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.DeactivateUser;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.DeactivateUsers;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.UpdateAgentInformation;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.UpdateEmployeeInformation;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.UpdateSalesCommission;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.UpdateUserInformation;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.UserLogin;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.AddFeedback;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.CreateDepartment;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.DeleteFeedback;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.EditDepartment;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.EditFeedback;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.RegisterSalesItem;
ALTER SCHEMA UserPortalDevProc TRANSFER dbo.UpdateUserPassword;

