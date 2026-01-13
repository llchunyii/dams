USE DAMS;
GO

ALTER TABLE Sales
ADD Region VARCHAR(50);
-- separate execution----

UPDATE Sales SET Region = 'Penang' WHERE AgentID = 6;
UPDATE Sales SET Region = 'Sarawak' WHERE AgentID = 7;
UPDATE Sales SET Region = 'Kelantan'  WHERE AgentID = 8;
UPDATE Sales SET Region = 'Melaka'  WHERE AgentID = 9;
UPDATE Sales SET Region = 'Johor' WHERE AgentID = 10;