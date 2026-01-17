USE DAMS;
GO


CREATE OR ALTER PROCEDURE UpdatePromotionProducts
	@PromotionProductID INT,
	@PromotionID INT = Null
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 FROM PromotionProduct WHERE PromotionProductID = @PromotionProductID)
		BEGIN
			RAISERROR('PromotionProduct ID %d does not exist.',16,1,@PromotionProductID);
            ROLLBACK TRANSACTION;
            RETURN;
		END

		IF @PromotionID IS NOT NULL 
		   AND NOT EXISTS (SELECT 1 FROM Promotion WHERE PromotionID = @PromotionID)
		BEGIN
			RAISERROR('Promotion ID %d does not exist.',16,1,@PromotionID);
            ROLLBACK TRANSACTION;
            RETURN;
		END

		IF @PromotionID IS NOT NULL
		IF EXISTS(
			SELECT 1
			FROM PromotionProduct pp
			WHERE pp.PromotionProductID != @PromotionProductID
			AND pp.ProductID = (SELECT ProductID FROM PromotionProduct WHERE PromotionProductID = @PromotionProductID)
			AND pp.PromotionID = @PromotionID
		)
		BEGIN
			RAISERROR('PromotionProduct already existed with the same attributes', 16, 1);
			ROLLBACK TRANSACTION
			RETURN;
		END
	
		DECLARE @SalesPrice DECIMAL(18,2);
		SET @SalesPrice = NULL;
		IF @PromotionID IS NOT NULL
		BEGIN
			SELECT
				@SalesPrice = p.Price * (1-promo.DiscountRate)
			FROM PromotionProduct pp
			LEFT JOIN Promotion promo ON @PromotionID = promo.PromotionID
			LEFT JOIN Products p ON pp.ProductID = p.ProductID
			WHERE pp.PromotionProductID = @PromotionProductID;
		END

		UPDATE PromotionProduct
		SET
			PromotionID = ISNULL(@PromotionID, PromotionID),
			SalesPrice = ISNULL(@SalesPrice, SalesPrice)
		WHERE PromotionProductID = @PromotionProductID;

		SELECT
			PromotionProductID,
			PromotionID,
			ProductID,
			SalesPrice
		FROM PromotionProduct
		WHERE PromotionProductID = @PromotionProductID;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_State();
		
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH

END;
GO