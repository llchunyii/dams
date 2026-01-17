USE DAMS;
GO

CREATE ROLE Marketing_Devs;
CREATE LOGIN Joshua WITH PASSWORD = 'Joshua123';
CREATE USER Joshua FOR LOGIN Joshua;

ALTER ROLE Marketing_Devs ADD MEMBER Joshua;

DENY SELECT, UPDATE ON OBJECT::dbo.[User] (Password) TO Marketing_Devs;
GRANT SELECT ON OBJECT::dbo.Campaign TO Marketing_Devs;
GRANT SELECT ON OBJECT::dbo.Promotion TO Marketing_Devs;
GRANT SELECT ON OBJECT::dbo.PromotionProduct TO Marketing_Devs;
GRANT SELECT ON OBJECT::dbo.Sales TO Marketing_Devs;
GRANT SELECT ON OBJECT::dbo.SalesItem TO Marketing_Devs;
GRANT SELECT ON OBJECT::dbo.Products TO Marketing_Devs;
GRANT EXECUTE ON SCHEMA::MarketingProc TO Marketing_Devs;
GRANT UNMASK ON OBJECT::dbo.Promotion TO Marketing_Devs;
GRANT UNMASK ON OBJECT::dbo.PromotionProduct TO Marketing_Devs;
GRANT UNMASK ON OBJECT::dbo.SalesItem TO Marketing_Devs;
GRANT UNMASK ON OBJECT::dbo.Sales TO Marketing_Devs;
GRANT UNMASK ON OBJECT::dbo.Campaign TO Marketing_Devs;
GRANT UNMASK ON OBJECT::dbo.Products TO Marketing_Devs;