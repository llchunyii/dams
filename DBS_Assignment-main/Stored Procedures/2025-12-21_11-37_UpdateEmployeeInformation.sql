USE DAMS;
GO
CREATE OR ALTER PROCEDURE UpdateEmployeeInformation(
	@UserID INT,
	@Username NVARCHAR(50) = NULL,
	@Name NVARCHAR(50) = NULL,
	@Phone NVARCHAR(20) = NULL,
	@Email NVARCHAR(100) = NULL,
	@Address NVARCHAR(500) = NULL,
	@DepartmentID INT = NULL,
	@Position NVARCHAR(100) = NULL
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

		IF NOT EXISTS (SELECT 1 FROM [dbo].[Employee] WHERE [EmployeeID] = @UserID)
		BEGIN;
			THROW 50001, 'Employee not found', 1;
			RETURN;
		END

		BEGIN TRANSACTION;
			EXEC UpdateUserInformation
				@UserID,
				@Username,
				@Name,
				@Phone,
				@Email,
				@Address

			UPDATE [dbo].[Employee]
			SET
				[DepartmentID] = ISNULL(@DepartmentID, [DepartmentID]),
				[JobTitle] = ISNULL(@Position, [JobTitle])
			WHERE
				[EmployeeID] = @UserID;


		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error updating employee information: ' + ERROR_MESSAGE();
		THROW;
	END CATCH
END


SELECT * FROM Employee