USE DAMS;
GO
CREATE OR ALTER PROCEDURE ViewAgentHistory
	@AgentId INT,
	@StartDate DATETIME2 = NULL,
	@EndDate DATETIME2 = NULL
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			IF @StartDate IS NULL AND @EndDate IS NULL
			BEGIN
				SELECT *, ValidFrom, ValidTo
				FROM Agents  
				FOR SYSTEM_TIME ALL AS a
				WHERE AgentId = @AgentId
				ORDER BY a.ValidFrom;
			END
			ELSE IF @StartDate IS NULL OR @EndDate IS NULL
			BEGIN;
				THROW 51101, 'Please enter start date and end date', 1;
			END
			ELSE 
			BEGIN
				SELECT *, ValidFrom, ValidTo
				FROM Agents
				FOR SYSTEM_TIME BETWEEN @StartDate AND @EndDate
				WHERE AgentId = @AgentId;
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error occured while viewing agents history' + ERROR_MESSAGE();
	END CATCH
END;
