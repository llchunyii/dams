USE DAMS;
GO

CREATE ROLE User_Portal_Devs;
CREATE LOGIN John WITH PASSWORD = 'John123';
CREATE USER John FOR LOGIN John;


ALTER ROLE User_Portal_Devs ADD MEMBER John;

GRANT EXECUTE ON SCHEMA::UserPortalDevProc TO User_Portal_Devs;
GRANT SELECT ON OBJECT::dbo.Feedback TO User_Portal_Devs;
DENY SELECT, UPDATE ON OBJECT::dbo.[User] (Password) TO User_Portal_Devs;
GRANT UNMASK ON OBJECT::dbo.[User] TO User_Portal_Devs;
GRANT UNMASK ON OBJECT::dbo.[Employee] TO User_Portal_Devs;
GRANT UNMASK ON OBJECT::dbo.[Agents] TO User_Portal_Devs;