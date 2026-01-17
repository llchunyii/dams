USE DAMS;
GO

CREATE SCHEMA SupplyChainProc;

GO

ALTER SCHEMA SupplyChainProc TRANSFER dbo.AddSupplier;
ALTER SCHEMA SupplyChainProc TRANSFER dbo.AddStockIn;
ALTER SCHEMA SupplyChainProc TRANSFER dbo.AddProducts;
ALTER SCHEMA SupplyChainProc TRANSFER dbo.UpdateProducts;
ALTER SCHEMA SupplyChainProc TRANSFER dbo.DeleteProducts;
ALTER SCHEMA SupplyChainProc TRANSFER dbo.DeleteSupplier;
ALTER SCHEMA SupplyChainProc TRANSFER dbo.UpdateStockIn;
ALTER SCHEMA SupplyChainProc TRANSFER dbo.UpdateSupplier;
