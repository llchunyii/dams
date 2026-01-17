USE DAMS;
GO

IF TYPE_ID('dbo.tvp_PromotionList') IS NOT NULL
	DROP TYPE dbo.tvp_PromotionList;
GO

CREATE TYPE dbo.tvp_PromotionList AS TABLE
(
	Name NVARCHAR(100),
	DiscountRate DECIMAL(5,2)
);
GO

CREATE OR ALTER PROCEDURE AddCampaignPromotions
	@CampaignID INT,
	@Promotions tvp_PromotionList READONLY
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 From Campaign WHERE CampaignID = @CampaignID)
		BEGIN
			RAISERROR('Campaign ID %d Campaign does not exist.', 16, 1, @CampaignID);
			ROLLBACK TRANSACTION;
			RETURN;
		END

		IF EXISTS (SELECT 1 FROM @Promotions WHERE DiscountRate < 0 OR DiscountRate > 1)
        BEGIN
            RAISERROR('Discount rate must be between 0 and 1.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

		IF EXISTS (
			SELECT 1
			FROM @Promotions p
			INNER JOIN Promotion existing
				ON existing.Name = p.Name
				AND existing.DiscountRate = p.DiscountRate
				AND existing.CampaignID = @CampaignID
		)
		BEGIN
            RAISERROR('One or more promotion type are already assigned to this campaign.', 16, 1);
			ROLLBACK TRANSACTION;
			RETURN;
        END


		DECLARE @Inserted TABLE(
			PromotionID INT,
			CampaignID INT,
			PromotionName NVARCHAR(100),
			DiscountRate DECIMAL(5,2)
		);

		INSERT INTO Promotion (CampaignID, Name, DiscountRate)
		OUTPUT
			INSERTED.PromotionID,
			INSERTED.CampaignID,
			INSERTED.Name,
			INSERTED.DiscountRate
		INTO @Inserted
		SELECT
			@CampaignID,
			Name,
			DiscountRate
		FROM @Promotions;
		
		SELECT
			PromotionID,
			CampaignID,
			PromotionName,
			DiscountRate
		FROM @Inserted;

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