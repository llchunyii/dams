USE DAMS;
GO

CREATE OR ALTER PROCEDURE GetPromotionTotalSalesAmount
	@PromotionName NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM Promotion p WHERE p.Name = @PromotionName)
		BEGIN
			RAISERROR('Promotion Name %s does not exist.', 16, 1, @PromotionName);
			RETURN;
		END

		SELECT
			p.Name AS PromotionName,
			p.DiscountRate,
			COUNT(DISTINCT pp.PromotionProductID) AS TotalPromotionProducts,
			COUNT(DISTINCT s.SalesID) AS TotalSalesTransactions,
			SUM(s.Quantity) AS TotalItemSold,
			ISNULL(SUM(s.Subtotal),0) AS TotalSalesAmount
		FROM Promotion p
		LEFT JOIN PromotionProduct pp ON p.PromotionID = pp.PromotionID
		LEFT JOIN SalesItem s ON pp.PromotionProductID = s.PromotionProductID
		WHERE p.Name = @PromotionName
		GROUP BY p.Name, p.DiscountRate;

	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_State();

		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH

END;
GO