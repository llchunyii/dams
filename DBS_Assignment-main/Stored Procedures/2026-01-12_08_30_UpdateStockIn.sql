USE DAMS;

GO


CREATE OR ALTER PROCEDURE UpdateStockIn
	@StockInID INT,
	@ProductID INT,
	@Quantity INT,
	@TotalCost DECIMAL(9, 2),
	@StockInDate DATETIME
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

			IF @StockInID IS NULL
			BEGIN;
				THROW 50901, 'Please enter StockIn id', 1;
				RETURN;
			END
            UPDATE StockIn 
            SET 
                [ProductID]   = ISNULL(@ProductID, [ProductID]),
                [Quantity]    = ISNULL(@Quantity, [Quantity]),
                [TotalCost]   = ISNULL(@TotalCost, [TotalCost]),
                [StockInDate] = ISNULL(@StockInDate, [StockInDate])
            WHERE StockInID = @StockInID;

			IF @@ROWCOUNT = 0 
			BEGIN
				;THROW 50902, 'Stock ID not found', 2;
			END
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT'Error encountered during stock in modification'  + ERROR_MESSAGE();
		THROW;
	END CATCH
END;



EXEC sp_help 'StockIn'