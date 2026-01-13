USE DAMS;
GO

CREATE OR ALTER PROCEDURE EditDepartment
	@DepartmentID INT,
	@Name NVARCHAR(100)
AS
BEGIN;
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

			IF @DepartmentID IS NULL
			BEGIN;
				THROW 50503, 'Please enter department ID', 1;
				RETURN;
			END
			IF @Name IS NULL
			BEGIN;
				THROW 50501, 'Please enter department name', 1;
				RETURN;
			END
			IF EXISTS (SELECT 1 FROM Department WHERE [Name] = @Name AND [DepartmentID] != @DepartmentID)
			BEGIN;
				THROW 50502, 'Department name already exists', 1;
				RETURN;
			END
			UPDATE Department
			SET [Name] = @Name
			WHERE [DepartmentID] = @DepartmentID;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error occured during department modification' + ERROR_MESSAGE();
		THROW;
	END CATCH;
	

END;