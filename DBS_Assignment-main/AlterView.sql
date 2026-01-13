USE DAMS;
GO

ALTER VIEW Audit_SalesTransactions AS
SELECT 
    s.SalesID,
    s.SalesDate,
    s.AgentID,
    a.AgentType,
    u.Name AS AgentName,
    s.TotalAmount,
    s.Region,  
    c.CommissionAmount,
    c.CommissionRate
FROM Sales s
LEFT JOIN Agents a ON s.AgentID = a.AgentID
LEFT JOIN [User] u ON a.AgentID = u.UserID
LEFT JOIN Commission c ON s.SalesID = c.SalesID;
GO
-- Select* from Audit_SalesTransactions

ALTER VIEW Analytics_SalesTrend AS
SELECT 
    YEAR(s.SalesDate) AS SalesYear,
    MONTH(s.SalesDate) AS SalesMonth,
    a.AgentType,
    s.Region,  -- NEW
    COUNT(s.SalesID) AS TotalTransactions,
    SUM(s.TotalAmount) AS TotalRevenue,
    AVG(s.TotalAmount) AS AverageOrderValue
FROM Sales s
LEFT JOIN Agents a ON s.AgentID = a.AgentID
GROUP BY YEAR(s.SalesDate), MONTH(s.SalesDate), a.AgentType, s.Region;
GO
-- Select* from Analytics_SalesTrend

ALTER VIEW Audit_FinancialSummary AS
SELECT 
    YEAR(s.SalesDate) AS FiscalYear,
    MONTH(s.SalesDate) AS FiscalMonth,
    a.AgentType,
    s.Region,  -- NEW
    COUNT(DISTINCT s.SalesID) AS TotalTransactions,
    SUM(s.TotalAmount) AS TotalSalesRevenue,
    SUM(c.CommissionAmount) AS TotalCommissionPaid,
    SUM(s.TotalAmount) - SUM(c.CommissionAmount) AS NetRevenue
FROM Sales s
LEFT JOIN Agents a ON s.AgentID = a.AgentID
LEFT JOIN Commission c ON s.SalesID = c.SalesID
GROUP BY YEAR(s.SalesDate), MONTH(s.SalesDate), a.AgentType, s.Region;
GO
-- Select* from Audit_FinancialSummary

ALTER VIEW Portal_AgentSalesHistory AS
SELECT 
    s.SalesID,
    s.SalesDate,
    s.AgentID,
    a.AgentType,
    s.Region,  -- NEW
    s.TotalAmount,
    c.CommissionAmount,
    c.CommissionRate,
    CASE 
        WHEN s.SalesDate >= DATEADD(DAY, -7, GETDATE()) THEN 'Recent'
        WHEN MONTH(s.SalesDate) = MONTH(GETDATE()) THEN 'This Month'
        ELSE 'Historical'
    END AS Period
FROM Sales s
LEFT JOIN Agents a ON s.AgentID = a.AgentID
LEFT JOIN Commission c ON s.SalesID = c.SalesID;
GO
-- Select* from Portal_AgentSalesHistory

ALTER VIEW Manager_Dashboard AS
SELECT 
    'Current Month' AS Period,
    COUNT(DISTINCT s.SalesID) AS TotalSales,
    SUM(s.TotalAmount) AS TotalRevenue,
    COUNT(DISTINCT s.AgentID) AS ActiveAgents
FROM Sales s
WHERE MONTH(s.SalesDate) = MONTH(GETDATE())
    AND YEAR(s.SalesDate) = YEAR(GETDATE())
UNION ALL
SELECT 
    'Previous Month',
    COUNT(DISTINCT s.SalesID),
    SUM(s.TotalAmount),
    COUNT(DISTINCT s.AgentID)
FROM Sales s
WHERE MONTH(s.SalesDate) = MONTH(DATEADD(MONTH, -1, GETDATE()))
    AND YEAR(s.SalesDate) = YEAR(DATEADD(MONTH, -1, GETDATE()));
GO
-- Select* from Manager_Dashboard
