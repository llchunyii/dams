USE DAMS;
GO

CREATE ROLE Analytics;
CREATE LOGIN Jane WITH PASSWORD = 'Jane123';
CREATE USER Jane FOR LOGIN Jane;

ALTER ROLE Analytics ADD MEMBER Jane;

GRANT SELECT ON OBJECT::dbo.Sales TO Analytics;
GRANT SELECT ON OBJECT::dbo.Campaign TO Analytics;
GRANT SELECT ON OBJECT::dbo.Promotion TO Analytics;
GRANT SELECT ON OBJECT::dbo.PromotionProduct TO Analytics;
GRANT SELECT ON OBJECT::dbo.Supplier (SupplierID, [Name]) TO Analytics;
GRANT SELECT ON OBJECT::dbo.SalesItem(SalesItemID, SalesID, PromotionProductID, Quantity, Subtotal) TO Analytics;
GRANT SELECT ON OBJECT::dbo.Products TO Analytics;
GRANT SELECT ON OBJECT::dbo.Commission TO Analytics;


DENY SELECT, UPDATE ON OBJECT::dbo.[User] (Password) TO Analytics;