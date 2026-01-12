USE DAMS;
GO


CREATE OR ALTER PROCEDURE AddCampaign
	@Name NVARCHAR(200),
	@StartDate DATE = NULL,
	@EndDate DATE = NULL,
	@NewCampaignID INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @EndDate < @StartDate
		BEGIN
			RAISERROR('End date must be greater than or equal to start date.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
		END
		
		IF @Name IS NULL
		BEGIN
			RAISERROR('Campaign name must not be empty', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
		END

		IF EXISTS (
			SELECT 1
			FROM Campaign c
			WHERE c.Name = @Name
			  AND c.StartDate IS NOT DISTINCT FROM @StartDate  
			  AND c.EndDate   IS NOT DISTINCT FROM @EndDate      
		)
		BEGIN
			RAISERROR('A campaign with the same Name, StartDate, and EndDate already exists.', 16, 1);
			ROLLBACK TRANSACTION;
			RETURN;
		END


		INSERT INTO Campaign (Name, StartDate, EndDate)
		VALUES (@Name, @StartDate, @EndDate);

		SET @NewCampaignID = SCOPE_IDENTITY();

		SELECT
			CampaignID,
			Name,
			StartDate,
			EndDate
		FROM Campaign WHERE CampaignID = @NewCampaignID

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