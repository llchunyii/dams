USE DAMS;
GO

DENY EXECUTE ON SCHEMA::AdminProc TO User_Portal_Devs;
DENY EXECUTE ON SCHEMA::AdminProc TO Analytics;
DENY EXECUTE ON SCHEMA::AdminProc TO Marketing_Devs;
DENY EXECUTE ON SCHEMA::AdminProc TO Supply_Chain_Devs;
DENY EXECUTE ON SCHEMA::AdminProc TO Auditors;
DENY EXECUTE ON SCHEMA::AuditorProc TO User_Portal_Devs;
DENY EXECUTE ON SCHEMA::AuditorProc TO Analytics;
DENY EXECUTE ON SCHEMA::AuditorProc TO Marketing_Devs;
DENY EXECUTE ON SCHEMA::AuditorProc TO Supply_Chain_Devs;
