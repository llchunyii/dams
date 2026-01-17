--Sales Temporal Table
CREATE OR ALTER PROCEDURE dbo.TrackSales
    @SaleID INT = NULL,
    @StartDate DATETIME2 = NULL,
    @EndDate DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    --Default start date is 3 months ago
    IF @StartDate IS NULL
        SET @StartDate = DATEADD(MONTH, -3, SYSUTCDATETIME());
    
    --Defualt end date is current dt
    IF @EndDate IS NULL
        SET @EndDate = SYSUTCDATETIME(); 
    
    SELECT 
        *
    FROM dbo.Sales
        FOR SYSTEM_TIME BETWEEN @StartDate AND @EndDate
    WHERE (@SaleID IS NULL OR SalesID = @SaleID)
    ORDER BY SalesID, ValidFrom DESC;
END
GO

--Campaign Temporal Table
CREATE OR ALTER PROCEDURE dbo.TrackCampaign
    @CampaignID INT = NULL,
    @StartDate DATETIME2 = NULL,
    @EndDate DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    --Default start date is 6 months ago
    IF @StartDate IS NULL
        SET @StartDate = DATEADD(MONTH, -6, SYSUTCDATETIME());
    
    IF @EndDate IS NULL
        SET @EndDate = SYSUTCDATETIME();
    
    SELECT 
        *
    FROM dbo.Campaign
        FOR SYSTEM_TIME BETWEEN @StartDate AND @EndDate
    WHERE (@CampaignID IS NULL OR CampaignID = @CampaignID)
    ORDER BY CampaignID, ValidFrom DESC;
END
GO

--PromotionProduct Temporal Table
CREATE OR ALTER PROCEDURE dbo.TrackPromotionProduct
    @PromotionProductID INT = NULL,
    @StartDate DATETIME2 = NULL,
    @EndDate DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    --Default start date is 6 months ago
    IF @StartDate IS NULL
        SET @StartDate = DATEADD(MONTH, -6, SYSUTCDATETIME());
    
    IF @EndDate IS NULL
        SET @EndDate = SYSUTCDATETIME();
    
    SELECT 
        *
    FROM dbo.PromotionProduct
        FOR SYSTEM_TIME BETWEEN @StartDate AND @EndDate
    WHERE (@PromotionProductID IS NULL OR PromotionProductID = @PromotionProductID)
    ORDER BY PromotionProductID, ValidFrom DESC;
END
GO


--StockIn Temporal Table
CREATE OR ALTER PROCEDURE dbo.TrackStockIn
    @StockInID INT = NULL,
    @StartDate DATETIME2 = NULL,
    @EndDate DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    --Default start date is 3 months ago
    IF @StartDate IS NULL
        SET @StartDate = DATEADD(MONTH, -3, SYSUTCDATETIME());
    
    IF @EndDate IS NULL
        SET @EndDate = SYSUTCDATETIME();
    
    SELECT 
        *
    FROM dbo.StockIn
        FOR SYSTEM_TIME BETWEEN @StartDate AND @EndDate
    WHERE (@StockInID IS NULL OR StockInID = @StockInID)
    ORDER BY StockInID, ValidFrom DESC;
END
GO


--Campaign Temporal Table
CREATE OR ALTER PROCEDURE dbo.TrackSalesItem
    @SalesItemID INT = NULL,
    @StartDate DATETIME2 = NULL,
    @EndDate DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    --Default start date is 6 months ago
    IF @StartDate IS NULL
        SET @StartDate = DATEADD(MONTH, -6, SYSUTCDATETIME());
    
    IF @EndDate IS NULL
        SET @EndDate = SYSUTCDATETIME();
    
    SELECT 
        *
    FROM dbo.SalesItem
        FOR SYSTEM_TIME BETWEEN @StartDate AND @EndDate
    WHERE (@SalesItemID IS NULL OR SalesItemID = @SalesItemID)
    ORDER BY SalesItemID, ValidFrom DESC;
END
GO