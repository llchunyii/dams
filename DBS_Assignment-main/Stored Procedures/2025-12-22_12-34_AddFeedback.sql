USE DAMS;
GO

CREATE OR ALTER PROCEDURE AddFeedback
	@UserID INT,
	@Feedback NVARCHAR(2000) = NULL,
	@Rating INT 
AS
BEGIN;
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			INSERT INTO Feedback (
				Feedback,
				Rating,
				UserID
			)
			VALUES (
				@Feedback,
				@Rating,
				@UserID
			)
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error occured during add feedback' + ERROR_MESSAGE();
		THROW;
	END CATCH;
	

END;
