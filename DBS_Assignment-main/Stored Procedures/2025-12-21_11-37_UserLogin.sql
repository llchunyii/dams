USE DAMS;
GO
CREATE OR ALTER PROCEDURE UserLogin(
	@Username NVARCHAR(50),
	@Password NVARCHAR(100)
)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

			DECLARE @PasswordHash VARBINARY(MAX),
				@IsValid BIT = 0,
				@Message NVARCHAR(100);
			SET @PasswordHash = HASHBYTES('SHA2_256',@Password);
			IF @Username IS NULL
			BEGIN;
				THROW 51001, 'Please enter a username', 1;
				RETURN;
			END
			IF NOT EXISTS (SELECT 1 FROM [User] WHERE Username = @Username)
			BEGIN;
				THROW 51002, 'Username not found', 1;
				RETURN;
			END

			DECLARE @RightPasswordHash VARBINARY(MAX)
			SET @RightPasswordHash = (SELECT [Password] FROM [User] WHERE Username = @Username)
			
			IF @RightPasswordHash = @PasswordHash
			BEGIN
				SET @IsValid = 1;
				SET @Message = 'Login success';
				SELECT 
					@IsValid AS LoginSuccess,
					@Message AS Remarks;
			END
			ELSE
			BEGIN
				SET @Message = 'Login failed';
				SELECT 
					@IsValid AS LoginSuccess,
					@Message AS Remarks;
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error: ' + ERROR_MESSAGE();
		THROW;
	END CATCH
END

