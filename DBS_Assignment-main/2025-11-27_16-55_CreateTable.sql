--USE master;
--GO

--DROP Database DAMS;

--CREATE Database DAMS;

USE DAMS;
GO

CREATE TABLE [User] (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Password VARBINARY(MAX) NOT NULL,     
    UserType NVARCHAR(20) NOT NULL CHECK (UserType IN ('Employee', 'Agent')), 
    Name NVARCHAR(150) NOT NULL,
    Email NVARCHAR(256) NULL,
    Phone NVARCHAR(50) NULL,
    Address NVARCHAR(500) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
);
GO

CREATE TABLE Agents (
    AgentID INT PRIMARY KEY,
    AgentType NVARCHAR(20) CHECK (AgentType IN ('Retail','Wholesale','Online')),
    Status NVARCHAR(20) DEFAULT 'Active' CHECK (Status IN ('Active', 'Inactive')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Agent_AgentID FOREIGN KEY (AgentID) REFERENCES [User](UserID) ON DELETE CASCADE
);
GO

CREATE TABLE Supplier(
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    Email NVARCHAR(256) NULL,
    Phone NVARCHAR(50) NULL,
    Address NVARCHAR(500) NULL,
    Company NVARCHAR(500) NULL,
);
GO

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(18,2) NOT NULL,
    SupplierID INT NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Available' CHECK (Status IN ('Available', 'Unavailable')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Product_Supplier FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);
GO

CREATE TABLE StockIn(
    StockInID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    TotalCost DECIMAL(18,2) NOT NULL,
    StockInDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_StockIn_ProductID FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

CREATE TABLE Sales (
    SalesID INT IDENTITY(1,1) PRIMARY KEY,
    AgentID INT NOT NULL,
    SalesDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_Sales_Agent FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);
GO

CREATE TABLE Campaign (
    CampaignID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    StartDate DATE NULL,
    EndDate DATE NULL,
);
GO

CREATE TABLE Promotion (
    PromotionID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignID INT NOT NULL,
    Name NVARCHAR(100),
    DiscountRate DECIMAL(5,2) NULL, 
    CONSTRAINT FK_Promotion_Campaign FOREIGN KEY (CampaignID) REFERENCES Campaign(CampaignID),
);
GO

CREATE TABLE PromotionProduct(
    PromotionProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,             
    PromotionID INT NULL,
    SalesPrice DECIMAL(18,2) NULL,
    CONSTRAINT FK_PromotionProduct_ProductID FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_PromotionProduct_PromotionID FOREIGN KEY (PromotionID) REFERENCES Promotion(PromotionID)
);
GO

CREATE TABLE SalesItem (
    SalesItemID INT IDENTITY(1,1) PRIMARY KEY,
    SalesID INT NOT NULL,
    PromotionProductID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    Subtotal DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_SalesItem_Sales FOREIGN KEY (SalesID) REFERENCES Sales(SalesID),
    CONSTRAINT FK_SalesItem_PromotionProductID FOREIGN KEY (PromotionProductID) REFERENCES PromotionProduct(PromotionProductID)
);
GO

CREATE TABLE Commission (
    CommissionID INT IDENTITY(1,1) PRIMARY KEY,
    SalesID INT NOT NULL,
    CommissionRate DECIMAL(5,2) NOT NULL,
    CommissionAmount DECIMAL(18,2) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Commission_Sales FOREIGN KEY (SalesID) REFERENCES Sales(SalesID)
);
GO

CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT NULL,
    JobTitle NVARCHAR(50),
    State NVARCHAR(20) DEFAULT 'Active' CHECK (State IN ('Active', 'Resign','Terminated')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Employee_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES [User](UserID) ON DELETE CASCADE,
    CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);
GO

CREATE TABLE Feedback (
    FeedbackID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Feedback NVARCHAR(1000) NOT NULL,
    Rating INT NULL CHECK (Rating BETWEEN 1 AND 5),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Feedback_User FOREIGN KEY (UserID) REFERENCES [User](UserID),
);
GO

CREATE TABLE ActivityLog (
    ActivityID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NULL,
    ActivityType NVARCHAR(100),
    DoneAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_ActivityLog_User FOREIGN KEY (UserID) REFERENCES [User](UserID)
);
GO


