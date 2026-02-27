-- 1. Create REGION Table
CREATE TABLE Region (
    Region_ID VARCHAR(10) PRIMARY KEY,
    Region_Name VARCHAR(100) NOT NULL,
    Comment VARCHAR(255)
);

-- 2. Create NATION Table
CREATE TABLE Nation (
    Nation_ID VARCHAR(10) PRIMARY KEY,
    Region_ID VARCHAR(10) NOT NULL,
    Nation_Name VARCHAR(100) NOT NULL,
    Comment VARCHAR(255),
    FOREIGN KEY (Region_ID) REFERENCES Region(Region_ID)
);

-- 3. Create CUSTOMER Table
CREATE TABLE Customer (
    Customer_ID VARCHAR(15) PRIMARY KEY,
    Nation_ID VARCHAR(10) NOT NULL,
    Name VARCHAR(150) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Phone_Number VARCHAR(20) NOT NULL,
    Account_Balance DECIMAL(10, 2) DEFAULT 0.00,
    Market_Segment VARCHAR(50),
    Comment VARCHAR(255),
    FOREIGN KEY (Nation_ID) REFERENCES Nation(Nation_ID)
);

-- 4. Create SUPPLIER Table
CREATE TABLE Supplier (
    Supplier_ID VARCHAR(15) PRIMARY KEY,
    Nation_ID VARCHAR(10) NOT NULL,
    Name VARCHAR(150) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Phone_Number VARCHAR(20) NOT NULL,
    Account_Balance DECIMAL(10, 2) DEFAULT 0.00,
    Comment VARCHAR(255),
    FOREIGN KEY (Nation_ID) REFERENCES Nation(Nation_ID)
);

-- 5. Create PART Table
CREATE TABLE Part (
    Part_ID VARCHAR(15) PRIMARY KEY,
    Part_Name VARCHAR(150) NOT NULL,
    Manufacturer VARCHAR(100),
    Brand VARCHAR(100),
    Type VARCHAR(100),
    Size VARCHAR(50),
    Container_Type VARCHAR(50),
    Retail_Price DECIMAL(10, 2) NOT NULL,
    Comment VARCHAR(255)
);

-- 6. Create SUPPLIER_PART Table (The Associative Entity for the M:N relationship)
CREATE TABLE Supplier_Part (
    Supplier_ID VARCHAR(15),
    Part_ID VARCHAR(15),
    Available_Quantity INT DEFAULT 0,
    Supply_Cost DECIMAL(10, 2) NOT NULL,
    Comment VARCHAR(255),
    PRIMARY KEY (Supplier_ID, Part_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
    FOREIGN KEY (Part_ID) REFERENCES Part(Part_ID)
);

-- 7. Create ORDER Table
CREATE TABLE Orders (
    Order_ID VARCHAR(15) PRIMARY KEY,
    Customer_ID VARCHAR(15) NOT NULL,
    Order_Date DATE NOT NULL,
    Order_Status VARCHAR(20) NOT NULL,
    Total_Price DECIMAL(12, 2) NOT NULL,
    Order_Priority VARCHAR(20),
    Clerk_Name VARCHAR(100),
    Shipping_Priority VARCHAR(20),
    Comment VARCHAR(255),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

-- 8. Create LINE_ITEM Table (The Weak Entity)
CREATE TABLE Line_Item (
    Order_ID VARCHAR(15),
    Line_Number INT,
    Supplier_ID VARCHAR(15) NOT NULL,
    Part_ID VARCHAR(15) NOT NULL,
    Quantity INT NOT NULL,
    Extended_Price DECIMAL(10, 2) NOT NULL,
    Discount DECIMAL(5, 2) DEFAULT 0.00,
    Tax DECIMAL(5, 2) DEFAULT 0.00,
    Return_Flag VARCHAR(1),
    Line_Status VARCHAR(20),
    Ship_Date DATE,
    Commit_Date DATE,
    Receipt_Date DATE,
    Ship_Instructions VARCHAR(255),
    Ship_Mode VARCHAR(50),
    Comment VARCHAR(255),
    PRIMARY KEY (Order_ID, Line_Number),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID) ON DELETE CASCADE,
    FOREIGN KEY (Supplier_ID, Part_ID) REFERENCES Supplier_Part(Supplier_ID, Part_ID)
);

-- 1. Insert Regions first (No foreign key dependencies)
INSERT INTO Region (Region_ID, Region_Name, Comment) 
VALUES 
    ('R1', 'North America', 'Primary market'),
    ('R2', 'Europe', 'Expanding market');

-- 2. Insert Nations (Depends on Region)
INSERT INTO Nation (Nation_ID, Region_ID, Nation_Name, Comment) 
VALUES 
    ('N1', 'R1', 'United States', 'HQ Location'),
    ('N2', 'R2', 'Germany', 'European Hub');

-- 3. Insert Customers (Depends on Nation)
INSERT INTO Customer (Customer_ID, Nation_ID, Name, Address, Phone_Number, Account_Balance, Market_Segment) 
VALUES 
    ('C1', 'N1', 'Tech Innovations Inc.', '123 Silicon Ave, CA', '555-0101', 50000.00, 'Technology'),
    ('C2', 'N2', 'Global Logistics', '456 Berlin Str, Berlin', '555-0202', 15000.00, 'Transport');

-- 4. Insert Suppliers (Depends on Nation)
INSERT INTO Supplier (Supplier_ID, Nation_ID, Name, Address, Phone_Number, Account_Balance) 
VALUES 
    ('S1', 'N1', 'Alpha Manufacturing', '789 Industrial Pkwy, TX', '555-0303', 100000.00),
    ('S2', 'N2', 'EuroParts Ltd.', '321 Munich Blvd, Munich', '555-0404', 75000.00);

-- 5. Insert Parts (No foreign key dependencies)
INSERT INTO Part (Part_ID, Part_Name, Manufacturer, Brand, Type, Size, Container_Type, Retail_Price) 
VALUES 
    ('P1', 'Industrial Processor', 'Alpha Mfg', 'ProTech', 'Electronics', 'Medium', 'Box', 1200.00),
    ('P2', 'Hydraulic Valve', 'EuroParts', 'FlowMax', 'Mechanical', 'Small', 'Pallet', 350.50);

-- 6. Insert Supplier_Part relationships (Depends on Supplier and Part)
-- This shows that S1 supplies P1, and S2 supplies P2. 
INSERT INTO Supplier_Part (Supplier_ID, Part_ID, Available_Quantity, Supply_Cost, Comment) 
VALUES 
    ('S1', 'P1', 500, 950.00, 'Volume discount applied'),
    ('S2', 'P2', 1200, 275.00, 'Standard supply agreement');

-- 7. Insert Orders (Depends on Customer)
INSERT INTO Orders (Order_ID, Customer_ID, Order_Date, Order_Status, Total_Price, Order_Priority, Clerk_Name) 
VALUES 
    ('O1', 'C1', '2026-02-20', 'Shipped', 2400.00, 'High', 'Alice'),
    ('O2', 'C2', '2026-02-25', 'Processing', 350.50, 'Normal', 'Bob');

-- 8. Insert Line Items (Depends on Order, and the Supplier_Part combination)
-- Note: Order O1 has 2 of Part P1 from Supplier S1. Order O2 has 1 of Part P2 from Supplier S2.
INSERT INTO Line_Item (Order_ID, Line_Number, Supplier_ID, Part_ID, Quantity, Extended_Price, Discount, Tax, Line_Status) 
VALUES 
    ('O1', 1, 'S1', 'P1', 2, 2400.00, 0.00, 120.00, 'Shipped'),
    ('O2', 1, 'S2', 'P2', 1, 350.50, 0.00, 17.50, 'Pending');