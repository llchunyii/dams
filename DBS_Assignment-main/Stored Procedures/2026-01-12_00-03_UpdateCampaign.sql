USE DAMS;
GO


CREATE OR ALTER PROCEDURE UpdateCampaign
	@CampaignID INT,
	@Name NVARCHAR(200) = NULL,
	@StartDate DATE = NULL,
	@EndDate DATE = NULL,
	@SetDateNull Bit = 0 
	--Must set this to 1 if want to set start date and end date to null,
	-- else by default the start date and end date will get existing value if input is null
	-- else if set to 1, no matter input have value will still set to null
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 FROM Campaign WHERE CampaignID = @CampaignID)
		BEGIN
			RAISERROR('Campaign ID %d does not exist.',16,1,@CampaignID);
            ROLLBACK TRANSACTION;
            RETURN;
		END

		IF @SetDateNull = 0
		BEGIN
			SET @StartDate = ISNULL(@StartDate, (SELECT StartDate FROM Campaign WHERE CampaignID = @CampaignID));
			SET @EndDate = ISNULL(@EndDate, (SELECT EndDate FROM Campaign WHERE CampaignID = @CampaignID));
		END
		ELSE
		BEGIN
			SET @StartDate = NULL;
			SET @EndDate = NULL;
		END


        IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @EndDate < @StartDate
        BEGIN
            RAISERROR('End date must be greater than or equal to start date.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS(
			SELECT 1
			FROM Campaign c
			WHERE c.CampaignID != @CampaignID
			AND c.Name = ISNULL(@Name, (SELECT Name FROM Campaign WHERE CampaignID = @CampaignID))
			AND c.StartDate IS NOT DISTINCT FROM @StartDate
			AND c.EndDate IS NOT DISTINCT FROM @EndDate
		)
		BEGIN
			RAISERROR('Campaign already existed with all the same attributes', 16, 1);
			ROLLBACK TRANSACTION
			RETURN;
		END


        UPDATE Campaign
        SET 
            Name = ISNULL(@Name, Name),
            StartDate = @StartDate,
            EndDate = @EndDate
        WHERE CampaignID = @CampaignID;

 
        SELECT 
            c.CampaignID,
            c.Name,
            c.StartDate,
            c.EndDate
        FROM Campaign c
        WHERE c.CampaignID = @CampaignID


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