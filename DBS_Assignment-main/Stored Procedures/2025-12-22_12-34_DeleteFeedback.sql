USE DAMS;
GO

CREATE OR ALTER PROCEDURE DeleteFeedback
	@FeedbackID INT,
	@Feedback NVARCHAR(2000) = NULL,
	@Rating INT = NULL
AS
BEGIN;
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

			IF @FeedbackID IS NULL 
			BEGIN;
				THROW 50401, 'Feedback ID cannot be null', 1;
				RETURN;
			END
			IF NOT EXISTS (SELECT 1 FROM Feedback WHERE FeedbackID = @FeedbackID)
			BEGIN;
				THROW 50402, 'Feedback ID does not exist', 1;
				RETURN;
			END

			DELETE Feedback
			WHERE FeedbackID = @FeedbackID;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error occured during edit feedback' + ERROR_MESSAGE();
		THROW;
	END CATCH;
END;
