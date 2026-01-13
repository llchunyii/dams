USE DAMS;

GO


CREATE OR ALTER PROCEDURE AddSupplier
	@Name NVARCHAR(300),
	@Address NVARCHAR(1000),
	@Email NVARCHAR(512),
	@Phone NVARCHAR(1000),
	@Company NVARCHAR(1000)

AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

			IF @Name IS NULL
			BEGIN;
				THROW 50601, 'Please enter supplier name', 1;
				RETURN;
			END
			IF @Address IS NULL
			BEGIN;
				THROW 50602, 'Please enter supplier address', 1;
				RETURN;
			END
			IF @Email IS NULL
			BEGIN;
				THROW 50603, 'Please enter supplier email', 1;
				RETURN;
			END
			IF @Company IS NULL
			BEGIN;
				THROW 50604, 'Please enter company name', 1;
				RETURN;
			END

			INSERT INTO Supplier 
			VALUES (
				@Name,
				@Email,
				@Phone,
				@Address,
				@Company
			);
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT'Error encountered during supplier creation'  + ERROR_MESSAGE();
		THROW;
	END CATCH
END;

