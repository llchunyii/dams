USE DAMS;
GO
CREATE OR ALTER PROCEDURE DeactivateUser
	@UserID INT
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			DECLARE @UserType NVARCHAR(50);
			SELECT @UserType = [UserType] FROM [dbo].[User] WHERE [UserID] = @UserID;

			IF @UserType = 'Employee'
			BEGIN
				UPDATE [dbo].[Employee]
				SET [State] = 'Terminated'
				WHERE [EmployeeID] = @UserID;
			END
			ELSE IF @UserType = 'Agent'
			BEGIN
				UPDATE [dbo].[Agents]
				SET [Status] = 'Inactive'
				WHERE [AgentID] = @UserID;
			END
			ELSE
			BEGIN
				PRINT 'Warning: User type ''' + @UserType + ''' is not valid!';			
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error: ' + ERROR_MESSAGE();
		THROW;
	END CATCH
END

