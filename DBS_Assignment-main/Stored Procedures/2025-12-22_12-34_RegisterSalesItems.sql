USE DAMS;
GO

CREATE OR ALTER PROCEDURE RegisterSalesItem
	@SalesID INT = NULL,
	@AgentID INT,
	@PromotionProductID INT,
	@Quantity INT,
	@SalesDate DATETIME = NULL
AS
BEGIN;
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			IF @PromotionProductID IS NULL
			BEGIN;
				THROW 50102, 'Please specify a product ID', 1;
				RETURN;
			END
			IF @Quantity IS NULL
			BEGIN;
				THROW 50103, 'Please specify a quantity', 1;
				RETURN;
			END

			IF @AgentID IS NULL
			BEGIN;
				THROW 50105, 'Please specify an agent ID', 1;
				RETURN;
			END

			IF NOT EXISTS (SELECT 1 FROM [dbo].[Agents] WHERE AgentID = @AgentID) 
			BEGIN;
				THROW 50106, 'Agent does not exists!',1;
				RETURN;
			END

			IF @SalesID IS NOT NULL
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM Sales WHERE SalesID = SalesID)
				BEGIN;
					THROW 50101, 'Sales ID does not exists', 2;
					RETURN
				END
			END
			ELSE IF @SalesID IS NULL
			BEGIN
				IF @SalesDate IS NULL
				BEGIN;
					THROW 50104, 'Please specify a sales date', 1;
					RETURN
				END
				INSERT INTO Sales(
					AgentID,
					SalesDate,
					TotalAmount
				)
				VALUES (
					@AgentID, 
					@SalesDate,
					0
				);
				SET @SalesID = SCOPE_IDENTITY();
			END
				DECLARE @SalesPrice DECIMAL(9,2)
				DECLARE @Subtotal DECIMAL(9,2)

				SET @SalesPrice = (SELECT SalesPrice FROM PromotionProduct WHERE PromotionProductID = @PromotionProductID);
				SET @Subtotal = @SalesPrice * @Quantity

				INSERT INTO [dbo].[SalesItem] (
					SalesID,
					PromotionProductID,
					Quantity,
					Subtotal
				)
				VALUES (
					@SalesID,
					@PromotionProductID,
					@Quantity,
					@Subtotal
				)
				UPDATE [dbo].[Sales]
				SET TotalAmount = TotalAmount + @Subtotal
				WHERE [SalesID] = @SalesID

				EXEC UpdateSalesCommission
					@SalesID;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error occured during sales item registration' + ERROR_MESSAGE();
		THROW;
	END CATCH;
END;

