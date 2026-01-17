USE DAMS;
GO

CREATE SCHEMA AuditorProc;

GO

ALTER SCHEMA AuditorProc TRANSFER dbo.TrackSales;
ALTER SCHEMA AuditorProc TRANSFER dbo.TrackCampaign;
ALTER SCHEMA AuditorProc TRANSFER dbo.TrackPromotionProduct;
ALTER SCHEMA AuditorProc TRANSFER dbo.TrackStockIn;
ALTER SCHEMA AuditorProc TRANSFER dbo.TrackSalesItem;
ALTER SCHEMA AuditorProc TRANSFER dbo.ViewAgentHistory;
ALTER SCHEMA AuditorProc TRANSFER dbo.ViewCommissionHistory;
ALTER SCHEMA AuditorProc TRANSFER dbo.ViewEmployeeHistory;
ALTER SCHEMA AuditorProc TRANSFER dbo.ViewProductsHistory;
ALTER SCHEMA AuditorProc TRANSFER dbo.ViewSupplierHistory;
ALTER SCHEMA AuditorProc TRANSFER dbo.ViewUserHistory;
ALTER SCHEMA AuditorProc TRANSFER dbo.GetAdministrativeAuditData;
ALTER SCHEMA AuditorProc TRANSFER dbo.GetSchemaAuditData;
ALTER SCHEMA AuditorProc TRANSFER dbo.GetSecurityAuditData;
ALTER SCHEMA AuditorProc TRANSFER dbo.GetAdministrativeAuditData;

