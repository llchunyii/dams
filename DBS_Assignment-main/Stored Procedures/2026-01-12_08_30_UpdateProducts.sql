USE DAMS;

GO

CREATE OR ALTER PROCEDURE UpdateProducts
	@ID INT,
	@Name NVARCHAR(400),
	@Description NVARCHAR(1000),
	@Price DECIMAL(9,2),
	@SupplierID INT,
	@Status NVARCHAR(40)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			IF @SupplierID IS NULL 
			BEGIN;
				THROW 50708, 'Supplier ID cannot be null', 1;
				RETURN;
			END
			UPDATE Products
			SET 
				[Name] = ISNULL(@Name, [Name]),
				[Description] = ISNULL(@Description, [Description]),
				[Price] = ISNULL(@Price, [Price]),
				[SupplierID] = ISNULL(@SupplierID, [SupplierID]),
				[Status] = ISNULL(@Status, [Status])
			WHERE ProductID = @ID;

			IF @@ROWCOUNT = 0 
			BEGIN
				;THROW 50709, 'Product ID not found', 2;
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'An error has occured during product modification ' + ERROR_MESSAGE();
		THROW
	END CATCH;
END;

