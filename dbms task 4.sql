CREATE DATABASE EcommerceDB;

USE EcommerceDB;

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    Address VARCHAR(200)
);

INSERT INTO Customer VALUES
(1, 'Rahul', 'rahul@gmail.com', '9876543210', 'Chennai'),
(2, 'Arun', 'arun@gmail.com', '9876543211', 'Nagercoil'),
(3, 'Priya', 'priya@gmail.com', '9876543212', 'Kanyakumari');

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Category_ID INT,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0)
);

INSERT INTO Product VALUES
(101, 'Laptop', 1, 65000, 10),
(102, 'Mouse', 2, 2500, 20),
(103, 'Mobile Phone', 3, 45000, 15),
(104, 'Keyboard', 2, 3000, 25),
(105, 'Headphone', 4, 5000, 30);

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    Total_Amount DECIMAL(10,2) CHECK (Total_Amount >= 0),
    Order_Status VARCHAR(20) NOT NULL
    CHECK (Order_Status IN ('Pending', 'Shipped', 'Delivered')),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

CREATE TABLE Order_Details (
    Order_Detail_ID INT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

INSERT INTO Orders
VALUES (5001, 1, '2026-10-08', 70000, 'Pending');

INSERT INTO Orders
VALUES (5002, 2, '2026-10-08', 45000, 'Pending');

INSERT INTO Orders
VALUES (5003, 3, '2026-10-08', 5000, 'Shipped');

INSERT INTO Order_Details
VALUES (1, 5001, 101, 1, 65000);

INSERT INTO Order_Details
VALUES (2, 5001, 102, 2, 2500);

INSERT INTO Order_Details
VALUES (3, 5002, 103, 1, 45000);

INSERT INTO Order_Details
VALUES (4, 5003, 105, 1, 5000);

SELECT Order_ID, SUM(Quantity * Price) AS Total_Amount
FROM Order_Details
GROUP BY Order_ID;

UPDATE Orders
SET Order_Status = 'Delivered'
WHERE Order_ID = 5001;

UPDATE Order_Details
SET Quantity = 3
WHERE Order_Detail_ID = 2;

SELECT Customer.Customer_Name,
       Orders.Order_ID,
       Orders.Order_Date,
       Orders.Total_Amount,
       Orders.Order_Status
FROM Customer
JOIN Orders
ON Customer.Customer_ID = Orders.Customer_ID;

SELECT Product.Product_Name,
       COUNT(Order_Details.Order_ID) AS Times_Ordered,
       SUM(Order_Details.Quantity) AS Total_Quantity_Sold
FROM Product
JOIN Order_Details
ON Product.Product_ID = Order_Details.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name;

SELECT Customer.Customer_Name,
       COUNT(Orders.Order_ID) AS Total_Orders
FROM Customer
JOIN Orders
ON Customer.Customer_ID = Orders.Customer_ID
GROUP BY Customer.Customer_ID, Customer.Customer_Name
ORDER BY Total_Orders DESC;

SELECT Customer.Customer_Name,
       SUM(Orders.Total_Amount) AS Total_Spending
FROM Customer
JOIN Orders
ON Customer.Customer_ID = Orders.Customer_ID
GROUP BY Customer.Customer_ID, Customer.Customer_Name;

SELECT Customer.Customer_Name,
       AVG(Orders.Total_Amount) AS Average_Order_Value
FROM Customer
JOIN Orders
ON Customer.Customer_ID = Orders.Customer_ID
GROUP BY Customer.Customer_ID, Customer.Customer_Name;

SELECT SUM(Total_Amount) AS Total_Sales
FROM Orders;

SELECT Customer.Customer_Name,
       Orders.Order_ID,
       Orders.Order_Date,
       Product.Product_Name,
       Order_Details.Quantity,
       Order_Details.Price,
       (Order_Details.Quantity * Order_Details.Price) AS Product_Total
FROM Customer
JOIN Orders
ON Customer.Customer_ID = Orders.Customer_ID
JOIN Order_Details
ON Orders.Order_ID = Order_Details.Order_ID
JOIN Product
ON Order_Details.Product_ID = Product.Product_ID;

DELETE FROM Order_Details
WHERE Order_ID = 5002;

DELETE FROM Orders
WHERE Order_ID = 5002;