USE [DAMS];
GO


EXEC CreateNewAgent
	'bonjames',
	'bron',
	'01938540923',
	'bonjames@gmail.com',
	'bonjames23',
	'bon''s house',
	'Online'

BEGIN TRANSACTION;
SELECT * FROM [User]
EXEC UserLogin
	'bonjames',
	'bonjamess23'


BEGIN TRANSACTION;
SELECT * FROM Department;