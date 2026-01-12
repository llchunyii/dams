USE DAMS;

GO


CREATE OR ALTER PROCEDURE UpdateSupplier
	@SupplierID INT,
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

			IF @SupplierID IS NULL
			BEGIN;
				THROW 50801, 'Please enter supplier id', 1;
				RETURN;
			END

			UPDATE Supplier 
			SET 
                [Name]    = ISNULL(@Name, [Name]),
                [Address] = ISNULL(@Address, [Address]),
                [Email]   = ISNULL(@Email, [Email]),
                [Phone]   = ISNULL(@Phone, [Phone]),
                [Company] = ISNULL(@Company, [Company])
			WHERE SupplierID = @SupplierID;


			IF @@ROWCOUNT = 0 
			BEGIN
				;THROW 50802, 'Supplier ID not found', 2;
			END
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT'Error encountered during supplier modification'  + ERROR_MESSAGE();
		THROW;
	END CATCH
END;

