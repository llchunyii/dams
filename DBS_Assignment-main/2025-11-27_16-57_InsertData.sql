use DAMS;
GO

INSERT INTO Department (Name) VALUES
('Marketing'),
('User Portal Development'),
('Analytics'),
('Database Administration');

INSERT INTO [User] (Username, Password, UserType, Name, Email, Phone, Address)
VALUES
('alice.w',  HASHBYTES('SHA2_256','Pass@123'), 'Employee', 'Alice Wong', 'alice@company.com', '0123456789', 'Kuala Lumpur'),
('ben.lee',  HASHBYTES('SHA2_256','Pass@781'), 'Employee', 'Benjamin Lee', 'ben@company.com', '0125678901', 'Selangor'),
('carmen.t', HASHBYTES('SHA2_256','Pass@513'), 'Employee', 'Carmen Tan', 'carmen@company.com', '0136789012', 'Penang'),
('daniel.o', HASHBYTES('SHA2_256','Pass@152'), 'Employee', 'Daniel Ong', 'daniel@company.com', '0147890123', 'Johor'),
('emily.c',  HASHBYTES('SHA2_256','Pass@183'), 'Employee', 'Emily Chen', 'emily@company.com', '0158901234', 'Perak'),

('agent.sam', HASHBYTES('SHA2_256','Pass@223'), 'Agent', 'Sam Chua', 'sam@agent.com', '0161234567', 'Kuala Lumpur'),
('agent.lim', HASHBYTES('SHA2_256','Pass@523'), 'Agent', 'Lim Wei', 'lim@agent.com', '0162345678', 'Selangor'),
('agent.jane',HASHBYTES('SHA2_256','Pass@120'), 'Agent', 'Jane Tan', 'jane@agent.com', '0173456789', 'Johor'),
('agent.ong', HASHBYTES('SHA2_256','Pass@022'), 'Agent', 'Ong Min', 'ong@agent.com', '0184567890', 'Penang'),
('agent.ali', HASHBYTES('SHA2_256','Pass@520'), 'Agent', 'Ali Hassan', 'ali@agent.com', '0195678901', 'Sarawak'),

('adam.k',   HASHBYTES('SHA2_256','Pass@212'), 'Employee', 'Adam Khoo', 'adam@company.com', '0111122334', 'Melaka'),
('brenda.l', HASHBYTES('SHA2_256','Pass@555'), 'Employee', 'Brenda Lim', 'brenda@company.com', '0112233445', 'Perlis'),
('chloe.h',  HASHBYTES('SHA2_256','Pass@262'), 'Employee', 'Chloe Ho', 'chloe@company.com', '0113344556', 'Kedah'),
('kevin.t',  HASHBYTES('SHA2_256','Pass@115'), 'Employee', 'Kevin Tan', 'kevin@company.com', '0114455667', 'Kelantan'),
('mira.s',   HASHBYTES('SHA2_256','Pass@132'), 'Employee', 'Mira Singh', 'mira@company.com', '0115566778', 'Sabah');


INSERT INTO Agents (AgentID, AgentType, Status)
VALUES
(6, 'Retail', 'Active'),
(7, 'Wholesale', 'Active'),
(8, 'Online', 'Active'),
(9, 'Wholesale', 'Inactive'),
(10,'Retail', 'Active');

INSERT INTO Supplier (Name, Email, Phone, Address, Company)
VALUES
('Green Leaf Farms', 'contact@greenleaf.com', '0321456789', 'Kuala Lumpur', 'Green Leaf Farms Sdn Bhd'),
('FreshVeg Trading', 'sales@freshveg.com', '0376543210', 'Selangor', 'FreshVeg Trading Co.'),
('Organic Harvest', 'info@organicharvest.com', '0388899001', 'Penang', 'Organic Harvest Ltd.'),
('Healthy Greens', 'support@healthygreens.com', '0399123456', 'Johor', 'Healthy Greens Enterprise'),
('Veggie Delight', 'inquiry@veggiedelight.com', '0312345678', 'Melaka', 'Veggie Delight Sdn Bhd'),
('Nature’s Basket', 'order@naturesbasket.com', '0356789123', 'Kedah', 'Nature’s Basket'),
('EcoVeg Supply', 'supply@ecoveg.com', '0387654321', 'Perlis', 'EcoVeg Supply Co.'),
('Farm Fresh Co.', 'service@farmfresh.com', '0334567891', 'Pahang', 'Farm Fresh Co.'),
('Harvest Time', 'parts@harvesttime.com', '0345678912', 'Terengganu', 'Harvest Time Sdn Bhd'),
('Local Greens', 'help@localgreens.com', '0367890123', 'Kelantan', 'Local Greens Enterprise'),
('Green Valley', 'contact@greenvalley.com', '0323987654', 'Sarawak', 'Green Valley Farms'),
('Veggie World', 'sales@veggieworld.com', '0332123456', 'Sabah', 'Veggie World Ltd.'),
('Fresh Farm Hub', 'info@freshfarmhub.com', '0398765432', 'Labuan', 'Fresh Farm Hub Sdn Bhd'),
('Organic Roots', 'import@organicroots.com', '0311223344', 'Negeri Sembilan', 'Organic Roots Enterprise'),
('Urban Veggies', 'logistic@urbanveggies.com', '0344112233', 'Putrajaya', 'Urban Veggies Co.');

INSERT INTO Products (Name, Description, Price, SupplierID, Status)
VALUES
('Organic Kale', 'Fresh organic kale leaves', 12.50, 1, 'Available'),
('Cherry Tomatoes', 'Sweet organic cherry tomatoes', 8.90, 2, 'Available'),
('Cucumber', 'Crunchy organic cucumbers', 5.50, 3, 'Unavailable'),
('Carrots', 'Organic carrots', 6.20, 4, 'Available'),
('Lettuce', 'Organic lettuce', 7.10, 5, 'Available'),
('Spinach', 'Fresh baby spinach leaves', 6.50, 6, 'Unavailable'),
('Broccoli', 'Green broccoli florets', 9.00, 7, 'Available'),
('Red Bell Pepper', 'Organic red bell pepper', 8.00, 8, 'Available'),
('Green Bell Pepper', 'Fresh green bell pepper', 7.80, 9, 'Unavailable'),
('Zucchini', 'Fresh organic zucchini', 6.90, 10, 'Available'),
('Cabbage', 'Crispy green cabbage', 5.80, 11, 'Available'),
('Eggplant', 'Fresh purple eggplant', 6.50, 12, 'Available'),
('Asparagus', 'Tender asparagus stalks', 15.00, 13, 'Available'),
('Cauliflower', 'Organic cauliflower heads', 9.50, 14, 'Unavailable'),
('Radish', 'Fresh red radish', 4.50, 15, 'Available');

INSERT INTO StockIn (ProductID, Quantity, TotalCost, StockInDate)
VALUES
(4, 60, 300.00, '2025-9-01'),
(15, 30, 90.00, '2025-9-02'),
(2, 20, 140.00, '2025-9-03'),
(7, 40, 270.00, '2025-9-04'),
(3, 10, 33.00, '2025-9-05'),
(1, 30, 270.00, '2025-9-06'),
(12, 15, 60.00, '2025-9-07'),
(10, 20, 100.00, '2025-9-08'),
(5, 30, 180.00, '2025-9-09'),
(8, 20, 100.00, '2025-9-10'),
(11, 50, 270.00, '2025-9-11'),
(6, 5, 20.00, '2025-9-12'),
(1, 50, 450.00, '2025-9-13'),
(2, 80, 560.00, '2025-9-14'),
(5, 70, 420.00, '2025-9-15'),
(10, 40, 200.00, '2025-9-16'),
(15, 60, 180.00, '2025-9-17'),
(4, 40, 200.00, '2025-9-18'),
(7, 25, 168.75, '2025-9-19'),
(13, 10, 130.00, '2025-9-20'),
(12, 35, 140.00, '2025-9-21'),
(8, 30, 150.00, '2025-9-22'),
(9, 8, 56.00, '2025-9-23'),
(14, 12, 108.00, '2025-9-24'),
(3, 15, 49.50, '2025-9-25'),
(11, 25, 135.00, '2025-9-26'),
(13, 20, 260.00, '2025-9-27'),
(1, 20, 180.00, '2025-9-28'),
(2, 50, 350.00, '2025-9-29'),
(5, 25, 150.00, '2025-9-30');

INSERT INTO Sales (AgentID, SalesDate, TotalAmount)
VALUES
(6, '2025-10-02', 148.10),
(7, '2025-10-03', 216.50),
(8, '2025-10-15', 184.30),
(9, '2025-10-17', 198.08),
(10, '2025-10-19', 816.10),
(6, '2025-10-20', 56.25),
(7, '2025-10-21', 331.12),
(8, '2025-10-23', 388.02),
(9, '2025-10-25', 354.00),
(10, '2025-10-27', 161.00);

INSERT INTO Campaign (Name, StartDate, EndDate)
VALUES
('Healthy Veggie Week', '2025-10-01', '2025-10-07'),
('Organic Boost', '2025-10-01', '2025-10-14'),
('Green Living Sale', '2025-10-15', '2025-10-21'),
('Fresh Harvest Deals', '2025-10-15', '2025-10-28'),
('Winter Veggie Promo', '2025-10-17', '2025-10-24'),
('Spring Greens', '2025-10-19', '2025-10-21'),
('Detox Veggie Week', '2025-10-19', '2025-10-24'),
('Salad Lovers Promo', '2025-10-19', '2025-10-25'),
('Veggie Combo Sale', '2025-10-26', '2025-11-04'),
('Green Boost Offer', '2025-11-05', '2025-11-11');

INSERT INTO Promotion (CampaignID, Name, DiscountRate)
VALUES
(1, '50% Off Healthy Veggie Week', 0.50),
(2, '20% Off Cherry Tomatoes', 0.20),
(3, '30% Off Cucumber', 0.30),
(4, 'Buy 1 Get 1 Carrots', 0.50),
(5, '15% Off Lettuce', 0.15),
(6, 'Spinach 3 for 2 Deal', 0.33),
(7, 'Broccoli 50% Off Weekend', 0.50),
(8, 'Mixed Salad Combo Sale', 0.25),
(9, 'Veggie Combo Pack 30% Off', 0.30),
(10, 'Organic Veggie Pack Half Price', 0.50);

INSERT INTO PromotionProduct (ProductID, PromotionID, SalesPrice)
VALUES
(1, NULL, 12.50), 
(2, NULL, 8.90),  
(3, NULL, 5.50),
(4, NULL, 6.20), 
(5, NULL, 7.10),  
(6, NULL, 3.75),  
(7, NULL, 8.10),  
(8, NULL, 7.36),  
(9, NULL, 6.86),  
(10, NULL, 6.56),
(11, NULL, 5.22), 
(12, NULL, 5.53), 
(13, NULL, 7.20), 
(14, NULL, 8.74), 
(15, NULL, 4.95), 
(1, 1, 6.25),
(2, 2, 7.12), 
(3, 3, 3.85),   
(4, 4, 3.10),   
(5, 5, 6.04),  
(6, 6, 2.51),  
(7, 7, 4.05),   
(8, 8, 5.52),   
(9, 9, 4.80),   
(10, 10, 3.28);

INSERT INTO SalesItem (SalesID, PromotionProductID, Quantity, Subtotal)
VALUES
(1, 16, 4, 25.00),  
(1, 17, 5, 35.60),   
(1, 1, 7, 59.90),
(2, 18, 10, 38.50),
(2, 2, 20, 178.00),
(3, 3, 5, 27.50),
(3, 19, 8, 24.80),
(3, 3, 24, 132.00),
(4, 20, 2, 12.08),
(4, 4, 10, 62.00),
(4, 4, 20, 124.00),
(5, 21, 10, 25.10),
(5, 22, 20, 81.00),
(5, 5, 100, 710.00),
(6, 6, 5, 18.75),
(6, 6, 10, 37.50),
(7, 7, 8, 64.80),
(7, 8, 12, 88.32),
(7, 2, 20, 178.00),
(8, 9, 5, 34.30),
(8, 10, 12, 78.72),
(8, 3, 50, 275.00),
(9, 19, 30, 93.00),
(9, 11, 50, 261.00),
(10, 4, 10, 62.00),
(10, 15, 20, 99.00);

INSERT INTO Commission (SalesID, CommissionRate, CommissionAmount)
VALUES
(1,  0.05, 7.41),
(2,  0.05, 10.83),
(3,  0.05, 9.22),
(4,  0.05, 9.90),
(5, 0.08, 65.29),
(6,  0.03, 1.69),
(7,  0.05, 16.56),
(8,  0.05, 19.40),
(9,  0.05, 17.70),
(10, 0.05, 8.10);

INSERT INTO Employee (EmployeeID, DepartmentID, JobTitle, State)
VALUES
(1, 1, 'Manager', 'Active'),
(2, 2, 'Sales Supervisor', 'Active'),
(3, 3, 'Clerk', 'Active'),
(4, 4, 'Stock Handler', 'Terminated'),
(5, 1, 'HR Assistant', 'Active'),
(11, 1, 'Manager', 'Active'),
(12, 2, 'Sales Assistant', 'Active'),
(13, 3, 'Clerk', 'Resign'),
(14, 4, 'Stock Assistant', 'Active'),
(15, 1, 'HR Manager', 'Active');

INSERT INTO Feedback (UserID, Feedback, Rating)
VALUES
(6, 'Great service, fast response!', 5),
(7, 'Prices are reasonable and clear.', 4),
(8, 'Delivery was delayed slightly.', 3),
(9, 'Agent was very helpful.', 5),
(10, 'Product quality can be improved.', 3),
(6, 'App interface is easy to use.', 5),
(7, 'Support team was slow this time.', 2),
(8, 'Packaging was good.', 4),
(9, 'Would recommend to others.', 5),
(10, 'Some items missing from order.', 2),
(6, 'Overall experience was smooth.', 4),
(7, 'Need more payment options.', 3);

INSERT INTO ActivityLog (UserID, ActivityType, DoneAt)
VALUES
(6, 'User Login', '2025-10-03 09:02:15'),
(1, 'Viewed Product List', '2025-10-03 09:05:40'),
(2, 'Placed Order', '2025-10-03 09:12:58'),
(6, 'User Logout', '2025-10-03 09:20:10'),
(3, 'User Login', '2025-10-04 10:15:33'),
(7, 'Checked Commission Report', '2025-10-04 10:18:47'),
(7, 'User Logout', '2025-10-04 10:25:10'),
(14, 'User Login', '2025-10-06 11:00:12'),
(8, 'Viewed Promotion Details', '2025-10-06 11:04:30'),
(8, 'User Logout', '2025-10-06 11:10:02'),
(4, 'User Login', '2025-10-07 14:22:48'),
(9, 'Submitted Feedback', '2025-10-07 14:30:20'),
(9, 'User Logout', '2025-10-07 14:35:09'),
(10, 'User Login', '2025-10-08 08:50:17'),
(12, 'Updated Profile', '2025-10-08 08:58:44'),
(10, 'User Logout', '2025-10-08 09:05:31'),
(2, 'Created New Product', '2025-10-10 09:20:00'),
(1, 'Updated Supplier Information', '2025-10-10 11:45:33'),
(4, 'Recorded Stock In', '2025-10-11 10:15:12'),
(2, 'Generated Sales Report', '2025-10-12 16:32:49'),
(3, 'Edited Campaign Details', '2025-10-13 14:05:21'),
(1, 'User Management - Added New Agent', '2025-10-14 15:48:55');


