USE DAMS;
GO

CREATE SCHEMA MarketingProc;

GO

ALTER SCHEMA MarketingProc TRANSFER dbo.GetCampaignTotalSalesAmount;
ALTER SCHEMA MarketingProc TRANSFER dbo.GetPromotionTotalSalesAmount;
ALTER SCHEMA MarketingProc TRANSFER dbo.AddCampaignPromotions;
ALTER SCHEMA MarketingProc TRANSFER dbo.AddPromotionProducts;
ALTER SCHEMA MarketingProc TRANSFER dbo.AddCampaign;
ALTER SCHEMA MarketingProc TRANSFER dbo.UpdatePromotion;
ALTER SCHEMA MarketingProc TRANSFER dbo.UpdateCampaign;
ALTER SCHEMA MarketingProc TRANSFER dbo.UpdatePromotionProducts;
