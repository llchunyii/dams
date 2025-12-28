USE DAMS;
GO

CREATE OR ALTER PROCEDURE CreateDepartment
	@Name NVARCHAR(100)
AS
BEGIN;
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			IF @Name IS NULL
			BEGIN;
				THROW 50501, 'Please enter department name', 1;
				RETURN;
			END
			IF EXISTS (SELECT 1 FROM Department WHERE [Name] = @Name)
			BEGIN;
				THROW 50502, 'Department name already exists', 1;
				RETURN;
			END
			INSERT INTO Department
			VALUES (@Name);

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error occured during department creation' + ERROR_MESSAGE();
		THROW;
	END CATCH;
	

END;