USE DAMS;
GO

CREATE OR ALTER PROCEDURE UpdateUserPassword
	@UserID INT,
	@Password NVARCHAR(100)
AS
BEGIN;
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			DECLARE @PasswordHash VARBINARY(MAX)
			SET @PasswordHash = HASHBYTES('SHA2_256', @Password);

			UPDATE [dbo].[User]
			SET [Password] = @PasswordHash
			WHERE UserID = @UserID;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error occured during password update ' + ERROR_MESSAGE();
		THROW;
	END CATCH;
	

END;