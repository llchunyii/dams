USE DAMS;
GO
CREATE OR ALTER PROCEDURE CreateNewAgent(
	@Username NVARCHAR(50),
	@Name NVARCHAR(50),
	@Phone NVARCHAR(20),
	@Email NVARCHAR(100),
	@Password NVARCHAR(100),
	@Address NVARCHAR(500),
	@AgentType NVARCHAR(100)
)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @NewUserID INT;
		EXEC CreateNewUser
			@Username,
			@Name,
			@Phone,
			@Email,
			@Password,
			@Address,
			'Agent',
			@NewUserID OUTPUT;
	
		INSERT INTO [dbo].[Agents] (
			[AgentID],
			[Status],
			[AgentType]
		)
		VALUES(
			@NewUserID,
			'Active',
			@AgentType
		);

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error: ' + ERROR_MESSAGE();
		THROW;
	END CATCH
END

