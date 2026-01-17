USE DAMS;

GO

CREATE OR ALTER PROCEDURE AddProducts
	@Name NVARCHAR(400),
	@Description NVARCHAR(1000),
	@Price DECIMAL(9,2),
	@SupplierID INT,
	@Status NVARCHAR(40)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			IF @Name IS NULL 
			BEGIN;
				THROW 50701, 'Name cannot be null', 1;
				RETURN;
			END
			IF @Description IS NULL 
			BEGIN;
				THROW 50701, 'Description cannot be null', 1;
				RETURN;
			END
			IF @Price IS NULL 
			BEGIN;
				THROW 50701, 'Price cannot be null', 1;
				RETURN;
			END
			IF @SupplierID IS NULL 
			BEGIN;
				THROW 50701, 'Supplier ID cannot be null', 1;
				RETURN;
			END
			IF @Status IS NULL 
			BEGIN;
				THROW 50701, 'Status cannot be null', 1;
				RETURN;
			END

			INSERT INTO Products (
				[Name],
				[Description],
				[Price],
				[SupplierID],
				[Status]
			)
			VALUES (
				@Name,
				@Description,
				@Price,
				@SupplierID,
				@Status
			);
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'An error has occured during product creation ' + ERROR_MESSAGE();
		THROW
	END CATCH;
END;

