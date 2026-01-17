USE DAMS; 
Go 

---------------- Marketing Team ------------------

-- View 1: Active Campaigns with Promotion Details (Marketing team: manage ongoing campaigns)
Create view Marketing_Campaigns as 
Select 
	c.CampaignID,
    c.Name AS CampaignName,
    c.StartDate,
    c.EndDate,
    DATEDIFF(DAY, GETDATE(), c.EndDate) AS DaysRemaining,
    COUNT(p.PromotionID) AS TotalPromotions,
    CASE 
        WHEN GETDATE() BETWEEN c.StartDate AND c.EndDate THEN 'Active'
        WHEN GETDATE() < c.StartDate THEN 'Upcoming'
        ELSE 'Expired'
    END AS CampaignStatus
FROM Campaign c
LEFT JOIN Promotion p ON c.CampaignID = p.CampaignID
GROUP BY c.CampaignID, c.Name, c.StartDate, c.EndDate;
Go 
--Select* from Marketing_Campaigns

-- View 2: Promotion Performance Summary (Marketing team: analyze promotion effectiveness)
CREATE VIEW Marketing_PromotionPerformance AS
SELECT 
    pr.PromotionID,
    pr.Name AS PromotionName,
    pr.DiscountRate,
    c.Name AS CampaignName,
    c.StartDate,
    c.EndDate,
    COUNT(DISTINCT pp.PromotionProductID) AS ProductsInPromotion,
    COUNT(DISTINCT si.SalesItemID) AS TotalItemsSold,
    ISNULL(SUM(si.Subtotal), 0) AS TotalRevenue
FROM Promotion pr
INNER JOIN Campaign c ON pr.CampaignID = c.CampaignID
LEFT JOIN PromotionProduct pp ON pr.PromotionID = pp.PromotionID
LEFT JOIN SalesItem si ON pp.PromotionProductID = si.PromotionProductID
GROUP BY pr.PromotionID, pr.Name, pr.DiscountRate, c.Name, c.StartDate, c.EndDate;
GO
--Select* from Marketing_PromotionPerformance

-- View 3: Product Catalog for Marketing (Marketing team: product information without supplier details)
CREATE VIEW Marketing_ProductCatalog AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.Description,
    p.Price,
    p.Status,
    s.Company AS SupplierCompany,
    COUNT(DISTINCT pp.PromotionProductID) AS TimesPromoted,
    p.CreatedAt
FROM Products p
INNER JOIN Supplier s ON p.SupplierID = s.SupplierID
LEFT JOIN PromotionProduct pp ON p.ProductID = pp.ProductID AND pp.PromotionID IS NOT NULL
GROUP BY p.ProductID, p.Name, p.Description, p.Price, p.Status, s.Company, p.CreatedAt;
GO
--Select* from Marketing_ProductCatalog

-- View 4: Agent Performance for Marketing Campaigns (Marketing team: identify top-performing agents for targeted campaigns)
CREATE VIEW Marketing_AgentPerformance AS
SELECT 
    a.AgentID,
    u.Name AS AgentName,
    a.AgentType,
    LEFT(u.Email, 3) + '***@' + RIGHT(u.Email, CHARINDEX('@', REVERSE(u.Email)) - 1) AS MaskedEmail,
    COUNT(DISTINCT s.SalesID) AS TotalSales,
    SUM(s.TotalAmount) AS TotalRevenue,
    AVG(s.TotalAmount) AS AverageSaleAmount,
    MAX(s.SalesDate) AS LastSaleDate
FROM Agents a
INNER JOIN [User] u ON a.AgentID = u.UserID
LEFT JOIN Sales s ON a.AgentID = s.AgentID
WHERE a.Status = 'Active'
GROUP BY a.AgentID, u.Name, a.AgentType, u.Email;
GO
-- Select* from Marketing_AgentPerformance

----------------- Analytics Team ----------------------

-- View 1: Sales Trend Analysis (Analytics team: sales forecasting and trend analysis)
CREATE VIEW Analytics_SalesTrend as
select 
    YEAR(s.SalesDate) AS SaleYear,
    MONTH(s.SalesDate) AS SaleMonth,
    DATENAME(MONTH, s.SalesDate) AS MonthName,
    a.AgentType,
    COUNT(DISTINCT s.SalesID) AS TotalOrders,
    COUNT(DISTINCT s.AgentID) AS ActiveAgents,
    SUM(s.TotalAmount) AS TotalRevenue,
    AVG(s.TotalAmount) AS AverageSaleValue,
    SUM(c.CommissionAmount) AS TotalCommissionPaid
FROM Sales s
INNER JOIN Agents a ON s.AgentID = a.AgentID
LEFT JOIN Commission c ON s.SalesID = c.SalesID
GROUP BY YEAR(s.SalesDate), MONTH(s.SalesDate), DATENAME(MONTH, s.SalesDate), a.AgentType;
GO
--Select* from Analytics_SalesTrend

-- View 2: Product Performance Analytics (Analytics team: identify best products)
create view Analytics_ProductPerformance as
select
    p.ProductID,
    p.Name AS ProductName,
    p.Price AS CurrentPrice,
    p.Status,
    s.Company AS SupplierCompany,
    -- Stock metrics
    ISNULL(SUM(st.Quantity), 0) AS TotalStockIn,
    ISNULL(SUM(st.TotalCost), 0) AS TotalStockInCost,
    -- Sales metrics
    ISNULL(SUM(si.Quantity), 0) AS TotalUnitsSold,
    ISNULL(SUM(si.Subtotal), 0) AS TotalRevenue,
    -- Performance metrics
    CASE 
        WHEN ISNULL(SUM(si.Quantity), 0) > 100 THEN 'High Performer'
        WHEN ISNULL(SUM(si.Quantity), 0) BETWEEN 50 AND 100 THEN 'Medium Performer'
        WHEN ISNULL(SUM(si.Quantity), 0) BETWEEN 1 AND 49 THEN 'Low Performer'
        ELSE 'No Sales'
    END AS PerformanceCategory
FROM Products p
INNER JOIN Supplier s ON p.SupplierID = s.SupplierID
LEFT JOIN StockIn st ON p.ProductID = st.ProductID
LEFT JOIN PromotionProduct pp ON p.ProductID = pp.ProductID
LEFT JOIN SalesItem si ON pp.PromotionProductID = si.PromotionProductID
GROUP BY p.ProductID, p.Name, p.Price, p.Status, s.Company;
GO
--Select * from Analytics_ProductPerformance

-- View 3: Commission Analysis (Analytics team: analyze commission effectiveness)
CREATE VIEW Analytics_CommissionAnalysis As
select
    c.CommissionID,
    s.SalesID,
    a.AgentType,
    s.TotalAmount AS SalesAmount,
    c.CommissionRate,
    c.CommissionAmount,
    YEAR(s.SalesDate) AS Year,
    MONTH(s.SalesDate) AS Month,
    CAST((c.CommissionAmount / s.TotalAmount * 100) AS DECIMAL(5,2)) AS CommissionPercentage
FROM Commission c
INNER JOIN Sales s ON c.SalesID = s.SalesID
INNER JOIN Agents a ON s.AgentID = a.AgentID;
GO
--elect * from Analytics_CommissionAnalysis

-- View 4: Supplier Performance Metrics (Analytics team: supplier evaluation)
Create View Analytics_SupplierMetrics As
Select
    s.SupplierID,
    s.Name AS SupplierName,
    s.Company,
    LEFT(s.Email, 3) + '***' AS MaskedEmail,
    -- Product metrics
    COUNT(DISTINCT p.ProductID) AS TotalProducts,
    COUNT(DISTINCT CASE WHEN p.Status = 'Available' THEN p.ProductID END) AS AvailableProducts,
    -- Stock metrics
    ISNULL(SUM(st.Quantity), 0) AS TotalStockReceived,
    ISNULL(SUM(st.TotalCost), 0) AS TotalPurchaseValue,
    -- Sales performance
    ISNULL(SUM(si.Quantity), 0) AS TotalUnitsSold,
    ISNULL(SUM(si.Subtotal), 0) AS TotalRevenue
FROM Supplier s
LEFT JOIN Products p ON s.SupplierID = p.SupplierID
LEFT JOIN StockIn st ON p.ProductID = st.ProductID
LEFT JOIN PromotionProduct pp ON p.ProductID = pp.ProductID
LEFT JOIN SalesItem si ON pp.PromotionProductID = si.PromotionProductID
GROUP BY s.SupplierID, s.Name, s.Company, s.Email;
GO
--Select * From Analytics_SupplierMetrics

-- View 5: Customer Feedback Analysis (Analytics team: monitor service quality)
Create View Analytics_FeedbackSummary As
Select
    u.UserType,
    YEAR(f.CreatedAt) AS Year,
    MONTH(f.CreatedAt) AS Month,
    COUNT(f.FeedbackID) AS TotalFeedback,
    AVG(CAST(f.Rating AS FLOAT)) AS AverageRating,
    COUNT(CASE WHEN f.Rating >= 4 THEN 1 END) AS PositiveFeedback,
    COUNT(CASE WHEN f.Rating <= 2 THEN 1 END) AS NegativeFeedback,
    CAST(COUNT(CASE WHEN f.Rating >= 4 THEN 1 END) * 100.0 / COUNT(f.FeedbackID) AS DECIMAL(5,2)) AS SatisfactionRate
FROM Feedback f
INNER JOIN [User] u ON f.UserID = u.UserID
GROUP BY u.UserType, YEAR(f.CreatedAt), MONTH(f.CreatedAt);
GO
--Select * From Analytics_FeedbackSummary

------------ Agent (Portal) ----------------

-- View 1: Agent Profile (Portal: display agent profile)
-- Should be filtered by WHERE AgentID = CURRENT_USER in application layer
CREATE VIEW Portal_AgentProfile AS
SELECT 
    a.AgentID,
    u.Username,
    u.Name,
    -- Masked sensitive data
    LEFT(u.Email, 3) + '****@' + RIGHT(u.Email, CHARINDEX('@', REVERSE(u.Email)) - 1) AS MaskedEmail,
    LEFT(u.Phone, 3) + '-***-' + RIGHT(u.Phone, 4) AS MaskedPhone,
    LEFT(u.Address, 10) + '...' AS PartialAddress,
    a.AgentType,
    a.Status,
    a.CreatedAt AS MemberSince,
    -- Performance summary (visible to agent)
    COUNT(DISTINCT s.SalesID) AS TotalSales,
    ISNULL(SUM(s.TotalAmount), 0) AS TotalRevenue,
    ISNULL(SUM(c.CommissionAmount), 0) AS TotalCommissionEarned
FROM Agents a
INNER JOIN [User] u ON a.AgentID = u.UserID
LEFT JOIN Sales s ON a.AgentID = s.AgentID
LEFT JOIN Commission c ON s.SalesID = c.SalesID
WHERE a.Status = 'Active'
GROUP BY a.AgentID, u.Username, u.Name, u.Email, u.Phone, u.Address, a.AgentType, a.Status, a.CreatedAt;
GO
--Select * From Portal_AgentProfile

-- View 2: Available Products with Current Promotions (Portal: display product catalog to agents)
create view Portal_ProductCatalog as
select
    p.ProductID,
    p.Name AS ProductName,
    p.Description,
    p.Price AS RegularPrice,
    p.Status,
    pr.PromotionID,
    pr.Name AS PromotionName,
    pr.DiscountRate,
   
    CASE -- only show promotion if got 
        WHEN pr.PromotionID IS NOT NULL THEN pp.SalesPrice
        ELSE NULL
    END AS PromotionalPrice,
    CASE -- only calculate when there is promotion 
        WHEN pr.PromotionID IS NOT NULL AND pp.SalesPrice IS NOT NULL 
        THEN p.Price - pp.SalesPrice
        ELSE 0
    END AS Savings,
    
    c.Name AS CampaignName,
    c.EndDate AS PromotionEndDate
    
FROM Products p
LEFT JOIN PromotionProduct pp ON p.ProductID = pp.ProductID
LEFT JOIN Promotion pr ON pp.PromotionID = pr.PromotionID
LEFT JOIN Campaign c ON pr.CampaignID = c.CampaignID
WHERE p.Status = 'Available'
    AND (c.EndDate IS NULL OR c.EndDate >= GETDATE());
GO
--Select * from Portal_ProductCatalog

-- View 3: Agent Sales History (sales history to logged-in agent)
Create view Portal_AgentSalesHistory as
select
    s.SalesID,
    s.AgentID,
    s.SalesDate,
    s.TotalAmount,
    COUNT(DISTINCT si.SalesItemID) AS TotalItems,
    c.CommissionAmount,
    c.CommissionRate,
    -- Status indicator
    CASE 
        WHEN s.SalesDate >= DATEADD(DAY, -7, GETDATE()) THEN 'Recent'
        WHEN s.SalesDate >= DATEADD(DAY, -30, GETDATE()) THEN 'This Month'
        ELSE 'Historical'
    END AS SalesPeriod
FROM Sales s
LEFT JOIN SalesItem si ON s.SalesID = si.SalesID
LEFT JOIN Commission c ON s.SalesID = c.SalesID
GROUP BY s.SalesID, s.AgentID, s.SalesDate, s.TotalAmount, c.CommissionAmount, c.CommissionRate;
GO
--select* from Portal_AgentSalesHistory

-- View 4: Active Campaigns for Display (show current campaigns and promotions)
Create view Portal_ActiveCampaigns as
SELECT 
    c.CampaignID,
    c.Name AS CampaignName,
    c.StartDate,
    c.EndDate,
    COUNT(DISTINCT pr.PromotionID) AS TotalPromotions,
    COUNT(DISTINCT pp.ProductID) AS ProductsOnSale,
    DATEDIFF(DAY, GETDATE(), c.EndDate) AS DaysRemaining
FROM Campaign c
LEFT JOIN Promotion pr ON c.CampaignID = pr.CampaignID
LEFT JOIN PromotionProduct pp ON pr.PromotionID = pp.PromotionID
WHERE c.EndDate >= GETDATE()
GROUP BY c.CampaignID, c.Name, c.StartDate, c.EndDate;
GO
--Select* from Portal_ActiveCampaigns

----------------- Database (Admins) -------------------

-- View 1: User Management Overview (Account Monitoring) 
Create View DBA_UserManagement As 
Select
    u.UserID,
    u.Username,
    u.UserType,
    u.Name,
    u.Email,
    u.Phone,
    u.CreatedAt,
    -- user type
    CASE 
        WHEN u.UserType = 'Agent' THEN a.Status
        WHEN u.UserType = 'Employee' THEN e.State
        ELSE 'N/A'
    END AS AccountStatus,
    CASE 
        WHEN u.UserType = 'Agent' THEN a.AgentType
        WHEN u.UserType = 'Employee' THEN d.Name
        ELSE 'N/A'
    END AS TypeOrDepartment,
    -- Activity metrics
    COUNT(DISTINCT al.ActivityID) AS TotalActivities,
    MAX(al.DoneAt) AS LastActivity
FROM [User] u
LEFT JOIN Agents a ON u.UserID = a.AgentID
LEFT JOIN Employee e ON u.UserID = e.EmployeeID
LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
LEFT JOIN ActivityLog al ON u.UserID = al.UserID
GROUP BY u.UserID, u.Username, u.UserType, u.Name, u.Email, u.Phone, u.CreatedAt,
         a.Status, e.State, a.AgentType, d.Name;
GO
Select* from DBA_UserManagement

-- View 2: System Activity Monitor (System Usage Patterns)
Create view DBA_ActivityMonitor As
SELECT 
    al.ActivityID,
    al.UserID,
    u.Username,
    u.UserType,
    al.ActivityType,
    al.DoneAt,
    DATENAME(WEEKDAY, al.DoneAt) AS DayOfWeek,
    DATEPART(HOUR, al.DoneAt) AS HourOfDay
FROM ActivityLog al
INNER JOIN [User] u ON al.UserID = u.UserID;
GO
--Select* from DBA_ActivityMonitor

-- View 3: Database Statistics Summary (Quick Dashboard) 
Create view DBA_DatabaseStats as
select 
    'Total Users' AS Metric, 
    COUNT(*) AS Value,
    'Count' AS Unit
FROM [User]
UNION ALL
SELECT 'Active Agents', COUNT(*), 'Count'
FROM Agents WHERE Status = 'Active'
UNION ALL
SELECT 'Active Employees', COUNT(*), 'Count'
FROM Employee WHERE State = 'Active'
UNION ALL
SELECT 'Total Products', COUNT(*), 'Count'
FROM Products
UNION ALL
SELECT 'Available Products', COUNT(*), 'Count'
FROM Products WHERE Status = 'Available'
UNION ALL
SELECT 'Total Sales Records', COUNT(*), 'Count'
FROM Sales
UNION ALL
SELECT 'Total Sales Revenue', SUM(TotalAmount), 'MYR'
FROM Sales
UNION ALL
SELECT 'Total Commission Paid', SUM(CommissionAmount), 'MYR'
FROM Commission
UNION ALL
SELECT 'Active Campaigns', COUNT(*), 'Count'
FROM Campaign WHERE EndDate >= GETDATE()
UNION ALL
SELECT 'Total Feedback', COUNT(*), 'Count'
FROM Feedback
UNION ALL
SELECT 'Average Rating', AVG(CAST(Rating AS FLOAT)), 'Stars'
FROM Feedback
UNION ALL
SELECT 'Total Activities Logged', COUNT(*), 'Count'
FROM ActivityLog;
GO
--Select* From DBA_DatabaseStats

-- View 4: Data Integrity Check View (Identify Data Issues) 
Create view DBA_DataIntegrityCheck as
Select 
    'Sales without Commission' AS IssueType,
    COUNT(*) AS RecordCount,
    'Check Commission table' AS Recommendation
from Sales s
LEFT JOIN Commission c ON s.SalesID = c.SalesID
where c.CommissionID IS NULL
Union ALL
Select 
    'Products without Stock',
    COUNT(*),
    'Check StockIn records'
FROM Products p
LEFT JOIN StockIn st ON p.ProductID = st.ProductID
WHERE st.StockInID IS NULL
UNION ALL
SELECT 
    'Users without Activity',
    COUNT(*),
    'Check ActivityLog'
FROM [User] u
LEFT JOIN ActivityLog al ON u.UserID = al.UserID
WHERE al.ActivityID IS NULL
    AND u.CreatedAt < DATEADD(DAY, -7, GETDATE())
UNION ALL
SELECT 
    'Inactive Agents with Recent Sales',
    COUNT(DISTINCT a.AgentID),
    'Review Agent Status'
FROM Agents a
INNER JOIN Sales s ON a.AgentID = s.AgentID
WHERE a.Status = 'Inactive'
    AND s.SalesDate >= DATEADD(DAY, -30, GETDATE());
GO
--Select* from DBA_DataIntegrityCheck

-------------------- Audit Team ---------------------

-- View 1: Sales Audit Trail (Track Sales Transaction) 

Create View Audit_SalesTransactions as
SELECT 
    s.SalesID,
    s.AgentID,
    u.Name as AgentName,
    a.AgentType,
    s.SalesDate,
    s.TotalAmount,
    COUNT(si.SalesItemID) as ItemCount,
    SUM(si.Quantity) as TotalQuantity,
    c.CommissionRate,
    c.CommissionAmount,
    c.CreatedAt as CommissionRecordedAt
FROM Sales s
INNER JOIN Agents a ON s.AgentID = a.AgentID
INNER JOIN [User] u ON a.AgentID = u.UserID
LEFT JOIN SalesItem si ON s.SalesID = si.SalesID
LEFT JOIN Commission c ON s.SalesID = c.SalesID
GROUP BY s.SalesID, s.AgentID, u.Name, a.AgentType, s.SalesDate, 
         s.TotalAmount, c.CommissionRate, c.CommissionAmount, c.CreatedAt;
GO
--Select* FROM Audit_SalesTransactions

-- View 2: User Access Audit (Review User Access) 
CREATE VIEW Audit_UserAccess as
SELECT 
    u.UserID,
    u.Username,
    u.UserType,
    u.Name,
    u.CreatedAt AS AccountCreated,
    COUNT(al.ActivityID) AS TotalActivities,
    MIN(al.DoneAt) AS FirstActivity,
    MAX(al.DoneAt) AS LastActivity,
    DATEDIFF(DAY, MAX(al.DoneAt), GETDATE()) AS DaysSinceLastActivity,
    CASE 
        WHEN DATEDIFF(DAY, MAX(al.DoneAt), GETDATE()) > 90 THEN 'Inactive'
        WHEN DATEDIFF(DAY, MAX(al.DoneAt), GETDATE()) > 30 THEN 'Low Activity'
        ELSE 'Active'
    END AS ActivityStatus
FROM [User] u
LEFT JOIN ActivityLog al ON u.UserID = al.UserID
GROUP BY u.UserID, u.Username, u.UserType, u.Name, u.CreatedAt;
GO
--SELECT* FROM Audit_UserAccess

-- View 3: Financial Audit Summary (Financial Reporting / Commission) 
CREATE VIEW Audit_FinancialSummary as
SELECT 
    YEAR(s.SalesDate) AS FiscalYear,--FY
    MONTH(s.SalesDate) AS FiscalMonth,
    a.AgentType,
    COUNT(DISTINCT s.SalesID) AS TotalTransactions,
    SUM(s.TotalAmount) AS TotalSalesRevenue,
    SUM(c.CommissionAmount) AS TotalCommissionPaid,
    AVG(c.CommissionRate) AS AverageCommissionRate,
    SUM(s.TotalAmount) - SUM(c.CommissionAmount) AS NetRevenue
FROM Sales s
INNER JOIN Agents a ON s.AgentID = a.AgentID
LEFT JOIN Commission c ON s.SalesID = c.SalesID
GROUP BY YEAR(s.SalesDate), MONTH(s.SalesDate), a.AgentType;
GO
--Select* from Audit_FinancialSummary

-------------------- Management Team ------------------------

-- View 1: Dashboard Summary (Business Overview)
Create View Manager_Dashboard As
Select 
    'Current Month Sales' AS Metric,
    COUNT(DISTINCT SalesID) AS Count,
    SUM(TotalAmount) AS Amount,
    'MYR' AS Currency
FROM Sales
WHERE YEAR(SalesDate) = YEAR(GETDATE()) 
    AND MONTH(SalesDate) = MONTH(GETDATE())
UNION ALL
SELECT 
    'Previous Month Sales',
    COUNT(DISTINCT SalesID),
    SUM(TotalAmount),
    'MYR'
FROM Sales
WHERE YEAR(SalesDate) = YEAR(DATEADD(MONTH, -1, GETDATE()))
    AND MONTH(SalesDate) = MONTH(DATEADD(MONTH, -1, GETDATE()))
UNION ALL
SELECT 
    'Active Agents',
    COUNT(*),
    NULL,
    'Count'
FROM Agents WHERE Status = 'Active'
UNION ALL
SELECT 
    'Active Campaigns',
    COUNT(*),
    NULL,
    'Count'\\\\\\\\\\\\\\\\\\h;;;nk;kmvdkln\


FROM Campaign WHERE EndDate >= GETDATE()
UNION ALL
SELECT 
    'Customer Satisfaction',
    NULL,
    AVG(CAST(Rating AS FLOAT)),
    'Stars'
FROM Feedback
WHERE CreatedAt >= DATEADD(MONTH, -1, GETDATE());
GO
--Select* from Manager_Dashboard

-- View 2: Top Performing Agents (For Rewarding? ) 
Create View Manager_TopAgents As
SELECT TOP 100 PERCENT
    a.AgentID,
    u.Name AS AgentName,
    a.AgentType,
    COUNT(DISTINCT s.SalesID) AS TotalSales,
    SUM(s.TotalAmount) AS TotalRevenue,
    SUM(c.CommissionAmount) AS TotalCommission,
    AVG(s.TotalAmount) AS AverageSaleValue,
    MAX(s.SalesDate) AS LastSaleDate,
    DENSE_RANK() OVER (ORDER BY SUM(s.TotalAmount) DESC) AS RevenueRank
FROM Agents a
INNER JOIN [User] u ON a.AgentID = u.UserID
LEFT JOIN Sales s ON a.AgentID = s.AgentID
LEFT JOIN Commission c ON s.SalesID = c.SalesID
WHERE a.Status = 'Active'
GROUP BY a.AgentID, u.Name, a.AgentType
ORDER BY RevenueRank;
GO
--Select* from Manager_TopAgents
