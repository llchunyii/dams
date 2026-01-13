USE DAMS;
GO
CREATE OR ALTER PROCEDURE CreateNewEmployee(
	@Username NVARCHAR(50),
	@Name NVARCHAR(50),
	@Phone NVARCHAR(20),
	@Email NVARCHAR(100),
	@Password NVARCHAR(100),
	@Address NVARCHAR(500),
	@JobTitle NVARCHAR(100),
	@DepartmentID INT
)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @NewUserID INT
		EXEC CreateNewUser
			@Username,
			@Name,
			@Phone,
			@Email,
			@Password,
			@Address,
			'Employee',
			@NewUserID OUTPUT;

		INSERT INTO [dbo].[Employee] (
			[EmployeeID],
			[State],
			[DepartmentID],
			[JobTitle]
		)
		VALUES(
			@NewUserID,
			'Active',
			@DepartmentID,
			@JobTitle
		);

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error: ' + ERROR_MESSAGE();
		THROW;
	END CATCH
END

GO

