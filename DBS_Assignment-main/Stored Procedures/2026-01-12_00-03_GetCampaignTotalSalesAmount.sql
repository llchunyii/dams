USE DAMS;
GO

CREATE OR ALTER PROCEDURE GetCampaignTotalSalesAmount
	@CampaignID INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM Campaign WHERE CampaignID = @CampaignID)
		BEGIN
			RAISERROR('Campaign ID %d does not exist.',16,1,@CampaignID);
			RETURN;
		END

		SELECT
			c.CampaignID,
			c.Name AS CampaignName,
			c.StartDate,
			c.EndDate,
			COUNT(DISTINCT p.PromotionID) AS TotalPromotions,
			COUNT(DISTINCT s.SalesID) AS TotalSalesTransactions,
			SUM(s.Quantity) AS TotalItemsSold,
			ISNULL(SUM(s.Subtotal),0) AS TotalSalesAmount
		FROM Campaign c
		LEFT JOIN Promotion p ON c.CampaignID = p.CampaignID
		LEFT JOIN PromotionProduct pp on p.PromotionID = pp.PromotionID
		LEFT JOIN SalesItem s ON pp.PromotionProductID = s.PromotionProductID
		WHERE c.CampaignID = @CampaignID
		GROUP BY c.CampaignID, c.Name, c.StartDate, c.EndDate;

	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_State();

		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END;
GO