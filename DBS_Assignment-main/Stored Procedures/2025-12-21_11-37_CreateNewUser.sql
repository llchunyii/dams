USE DAMS;
GO
CREATE OR ALTER PROCEDURE CreateNewUser(
	@Username NVARCHAR(50),
	@Name NVARCHAR(50),
	@Phone NVARCHAR(20),
	@Email NVARCHAR(100),
	@Password NVARCHAR(100),
	@Address NVARCHAR(500),
	@UserType NVARCHAR(100),
	@NewUserID INT OUTPUT
)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @PasswordHash VARBINARY(MAX);
		SET @PasswordHash = HASHBYTES('SHA2_256', @Password);
		INSERT INTO [User] (
			[Username], 
			[Password], 
			[Address],
			[UserType],
			[Name],
			[Email],
			[Phone]
			)
		VALUES(
			@Username, 
			@PasswordHash,
			@Address,
			@UserType,
			@Name,
			@Email,
			@Phone
		);
		SET @NewUserID = SCOPE_IDENTITY();
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error: ' + ERROR_MESSAGE();
		THROW;
	END CATCH
END

