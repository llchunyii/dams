USE DAMS;

GO

CREATE OR ALTER PROCEDURE AddStockIn
	@ProductID INT,
	@Quantity INT,
	@TotalCost DECIMAL(9, 2),
	@StockInDate DATETIME
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			IF @ProductID IS NULL 
			BEGIN;
				THROW 50701, 'Name cannot be null', 1;
				RETURN;
			END
			IF @Quantity IS NULL 
			BEGIN;
				THROW 50702, 'Description cannot be null', 1;
				RETURN;
			END
			IF @TotalCost IS NULL 
			BEGIN;
				THROW 50703, 'Price cannot be null', 1;
				RETURN;
			END
			IF @StockInDate IS NULL 
			BEGIN;
				THROW 50704, 'Supplier ID cannot be null', 1;
				RETURN;
			END

			INSERT INTO StockIn
			VALUES (
				@ProductID,
				@Quantity,
				@TotalCost,
				@StockInDate
			);
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'An error has occured during stock in creation ' + ERROR_MESSAGE();
		THROW
	END CATCH;
END;


