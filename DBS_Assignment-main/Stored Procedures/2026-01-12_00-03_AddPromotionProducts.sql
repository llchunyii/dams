USE DAMS;
GO

IF TYPE_ID('dbo.tvp_PromotionProductList') IS NOT NULL
	DROP TYPE dbo.tvp_PromotionProductList;
GO

CREATE TYPE dbo.tvp_PromotionProductList AS TABLE
(
	ProductID INT
);
GO

CREATE OR ALTER PROCEDURE AddPromotionProducts
	@PromotionID INT,
	@PromotionProducts tvp_PromotionProductList READONLY
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 From Promotion WHERE PromotionID = @PromotionID)
		BEGIN
			RAISERROR('Promotion ID %d Promotion does not exist.', 16, 1, @PromotionID);
			ROLLBACK TRANSACTION;
			RETURN;
		END

		IF EXISTS(
			SELECT 1 FROM @PromotionProducts p
			WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = p.ProductID)
		)
		BEGIN
			RAISERROR('One or more Product IDs does not exist.', 16, 1);
			ROLLBACK TRANSACTION;
			RETURN;
		END

		IF EXISTS (
            SELECT 1 
            FROM @PromotionProducts pp
            INNER JOIN PromotionProduct existing 
                ON existing.ProductID = pp.ProductID 
               AND existing.PromotionID = @PromotionID
        )
        BEGIN
            RAISERROR('One or more products are already assigned to this promotion.', 16, 1);
			ROLLBACK TRANSACTION;
			RETURN;
        END

		DECLARE @Inserted TABLE (
            PromotionProductID INT,
            ProductID INT,
            SalesPrice DECIMAL(18,2)
        );

		INSERT INTO PromotionProduct (ProductID, PromotionID, SalesPrice)
        OUTPUT 
            INSERTED.PromotionProductID,
            INSERTED.ProductID,
            INSERTED.SalesPrice
        INTO @Inserted
        SELECT 
            pp.ProductID,
            @PromotionID,
            p.Price * (1.0 - promo.DiscountRate)        
        FROM @PromotionProducts pp
        INNER JOIN Products p ON p.ProductID = pp.ProductID
        INNER JOIN Promotion promo ON promo.PromotionID = @PromotionID;

        SELECT 
            i.PromotionProductID,
            i.ProductID,
            prod.Name AS ProductName,
            @PromotionID AS PromotionID,
            prod.Price AS OriginalPrice,
            promo.DiscountRate,
            i.SalesPrice AS PriceAfterDiscount
        FROM @Inserted i
        INNER JOIN Products prod ON prod.ProductID = i.ProductID
        INNER JOIN Promotion promo ON promo.PromotionID = @PromotionID;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_State();
		
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH

END;
GO