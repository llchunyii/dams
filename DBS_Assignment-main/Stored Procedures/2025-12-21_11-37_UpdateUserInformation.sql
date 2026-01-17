USE DAMS;
GO
CREATE OR ALTER PROCEDURE UpdateUserInformation(
	@UserID INT,
	@Username NVARCHAR(50),
	@Name NVARCHAR(50),
	@Phone NVARCHAR(20),
	@Email NVARCHAR(100),
	@Address NVARCHAR(500)
)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		IF @UserID IS NULL
		BEGIN;
			THROW 50000, 'User Id is required!', 1;
			RETURN;
		END
		IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [UserID] = @UserID)
		BEGIN;
			THROW 50001, 'User not found', 1;
			RETURN;
		END

		IF @Username IS NOT NULL
			AND EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Username] = @Username AND [UserID] != @UserID)
		BEGIN;
			THROW 50002, 'Username already exists please pick a different one', 1;
			RETURN;
		END
	
		IF @Email IS NOT NULL
			AND EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Email] = @Email AND [UserID] != @UserID)
		BEGIN;
			THROW 50003, 'Email already exists please pick a different one', 1;
			RETURN;
		END

		BEGIN TRANSACTION;
			UPDATE [dbo].[User]
			SET 
				[Name] = ISNULL(@Name, [Name]),
				[Username] = ISNULL(@Username, [Username]),
				[Phone] = ISNULL(@Phone, [Phone]),
				[Email] = ISNULL(@Email, [Email]),
				[Address] = ISNULL(@Address, [Address])
			WHERE [UserID] = @UserID;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error updating user information: ' + ERROR_MESSAGE();
		THROW;
	END CATCH
END

