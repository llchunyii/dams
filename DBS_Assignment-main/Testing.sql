USE [DAMS];
GO




EXEC CreateNewAgent 'bonjames23', 'Bron James', '0123034223', 'bronjames23@gmail.com', 'bronjames23', 'house', 'Online';
EXEC UpdateAgentInformation 6, 'Steph cur';
SELECT * FROM Agents 
FOR SYSTEM_TIME AS OF '2026-01-12'

SELECT * FROM Agents FOR SYSTEM_TIME AS OF '2026-01-01 14:30:05.1234567';

SELECT *, ValidTo, ValidFrom FROM Agents FOR SYSTEM_TIME ALL WHERE AgentID = 6;
SELECT *, ValidTo, ValidFrom FROM Agents FOR SYSTEM_TIME AS OF '2026-01-12 16:06:56'  WHERE AgentID = 6;