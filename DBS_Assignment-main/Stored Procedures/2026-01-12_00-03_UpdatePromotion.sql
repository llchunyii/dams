USE DAMS;
GO


CREATE OR ALTER PROCEDURE UpdatePromotion
	@PromotionID INT,
	@CampaignID INT = NULL,
	@Name NVARCHAR(100) = NULL,
	@DiscountRate DECIMAL(5,2) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 FROM Promotion WHERE PromotionID = @PromotionID)
		BEGIN
			RAISERROR('Promotion ID %d does not exist.',16,1,@PromotionID);
            ROLLBACK TRANSACTION;
            RETURN;
		END
		
		IF @DiscountRate IS NOT NULL AND (@DiscountRate < 0 OR @DiscountRate >1)
		BEGIN
			RAISERROR('Discount Rate must be between 0 and 1.',16,1);
            ROLLBACK TRANSACTION;
            RETURN;
		END

		IF @CampaignID IS NOT NULL 
		   AND NOT EXISTS (SELECT 1 FROM Campaign WHERE CampaignID = @CampaignID)
		BEGIN
			RAISERROR('Campaign ID %d does not exist.', 16, 1, @CampaignID);
			ROLLBACK TRANSACTION
			RETURN;
		END



		IF EXISTS(
			SELECT 1
			FROM Promotion p
			WHERE p.PromotionID != @PromotionID
			AND p.CampaignID = ISNULL(@CampaignID, (SELECT CampaignID FROM Promotion WHERE PromotionID = @PromotionID))
			AND p.Name = ISNULL(@Name, (SELECT Name FROM Promotion WHERE PromotionID = @PromotionID))
			AND p.DiscountRate = ISNULL(@DiscountRate,  (SELECT DiscountRate FROM Promotion WHERE PromotionID = @PromotionID))
		)
		BEGIN
			RAISERROR('Promotion already existed with the same attributes', 16, 1);
			ROLLBACK TRANSACTION
			RETURN;
		END
	


		UPDATE Promotion
		SET
			CampaignID = ISNULL(@CampaignID, CampaignID),
			Name = ISNULL(@Name,Name),
			DiscountRate = ISNULL(@DiscountRate, DiscountRate)
		WHERE PromotionID = @PromotionID;

		SELECT
			PromotionID,
			CampaignID,
			Name,
			DiscountRate
		FROM Promotion
		WHERE PromotionID = @PromotionID;

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