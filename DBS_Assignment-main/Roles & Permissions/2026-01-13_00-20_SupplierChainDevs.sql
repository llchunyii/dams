USE DAMS;
GO

CREATE ROLE Supply_Chain_Devs;
CREATE LOGIN Joseph WITH PASSWORD = 'Joseph123';
CREATE USER Joseph FOR LOGIN Joseph;

ALTER ROLE Supply_Chain_Devs ADD MEMBER Joseph;

DENY SELECT, UPDATE ON OBJECT::dbo.[User] (Password) TO Supply_Chain_Devs;
GRANT SELECT ON OBJECT::dbo.Supplier TO Supply_Chain_Devs;
GRANT SELECT ON OBJECT::dbo.StockIn TO Supply_Chain_Devs;
GRANT SELECT ON OBJECT::dbo.Products TO Supply_Chain_Devs;
GRANT UNMASK ON OBJECT::dbo.Supplier TO Supply_Chain_Devs;
GRANT UNMASK ON OBJECT::dbo.StockIn TO Supply_Chain_Devs;
GRANT UNMASK ON OBJECT::dbo.Products TO Supply_Chain_Devs;
GRANT EXECUTE ON SCHEMA::SupplyChainProc TO Supply_Chain_Devs;
