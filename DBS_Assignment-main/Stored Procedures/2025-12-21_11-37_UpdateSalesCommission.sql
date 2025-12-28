USE DAMS;
GO
CREATE OR ALTER PROCEDURE UpdateSalesCommission(
	@SalesID INT
)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			IF @SalesID IS NULL
			BEGIN;
				THROW 50201, 'Sales ID is required!', 1;
				RETURN;
			END

			IF NOT EXISTS (SELECT 1 FROM [dbo].[Sales] WHERE [SalesID] = @SalesID)
			BEGIN;
				THROW 50202, 'Sales not found', 1;
				RETURN;
			END

			IF NOT EXISTS (SELECT 1 FROM [dbo].[SalesItem] WHERE [SalesID] = @SalesID)
			BEGIN;
				THROW 50203, 'Sales record does not have any items', 1;
				RETURN;
			END

			IF NOT EXISTS (SELECT 1 FROM Commission WHERE SalesID = @SalesID)
			BEGIN
				INSERT INTO Commission(
					SalesID,
					CommissionAmount,
					CommissionRate
				)
				VALUES (
					@SalesID,
					0,
					0
				)
			END
			DECLARE @CommissionAmount Decimal(9,2)
			DECLARE @CommissionRate Decimal(3,2)
			DECLARE @SalesTotal Decimal(10,2)
			
			SELECT 
				@SalesTotal = SUM(Subtotal)
			FROM dbo.SalesItem
			WHERE SalesID = @SalesID
			GROUP BY SalesID;
			
			SET @CommissionRate = CASE
				WHEN @SalesTotal < 100 THEN 0.03
				WHEN @SalesTotal >= 100 AND @SalesTotal < 400 THEN 0.05
				WHEN @SalesTotal >= 400 THEN 0.08
			END;
			SET @CommissionAmount =	@CommissionRate * @SalesTotal


			IF @SalesTotal = 0
			BEGIN;
				THROW 50204, 'Sales total for the given sales id is 0', 2;
				RETURN
			END
			UPDATE Commission
			SET 
				CommissionRate = @CommissionRate,
				CommissionAmount = @CommissionAmount
			WHERE SalesID = @SalesID

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error calculating commission: ' + ERROR_MESSAGE();
		THROW;
	END CATCH
END

