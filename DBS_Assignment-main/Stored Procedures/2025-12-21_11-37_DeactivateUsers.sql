USE DAMS;
GO
CREATE OR ALTER PROCEDURE DeactivateUsers
	@UserID NVARCHAR(MAX),
	@UserType NVARCHAR(20)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			
			IF @UserType = 'Employee'
			BEGIN
				UPDATE [dbo].[Employee]
				SET [State] = 'Terminated'
				WHERE [EmployeeID] IN (
					SELECT CAST(value AS INT)
					FROM STRING_SPLIT(@UserID, ',')
				);
				PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' users deactivated';
			END
			ELSE IF @UserType = 'Agent'
			BEGIN
				UPDATE [dbo].[Agents]
				SET [Status] = 'Inactive'
				WHERE [AgentID] IN (
					SELECT CAST(value AS INT)
					FROM STRING_SPLIT(@UserID, ',')
				);

				PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' users deactivated';

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

