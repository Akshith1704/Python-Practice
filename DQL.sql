CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
);
INSERT INTO Users(user_id,name,email,phone)
VALUES
(1,Akshith,akshith.com,9182374121),
(2,Manu,manu.com,6305079367),
(3,Tej,tej.com,8885271525);

CREATE TABLE Sellers (
    seller_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
);
INSERT INTO Sellers(seller_id,name,email,phone)
VALUES
(101,Balu,bal.com,6302946761),
(102,Sam,sam.com,1234567890),
(103,Man,man.com,1234456789);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    seller_id INT,
    name VARCHAR(100),
    price DECIMAL(10, 2),
    stock INT,
    FOREIGN KEY (seller_id) REFERENCES Sellers(seller_id)
);
INSERT INTO Products(product_id, seller_id, price, stock)
VALUES
(1234, 101, 1704, 17),
(1245, 102, 0417, 04),
(1704, 103, 1407, 174);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP,
    status VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
INSERT INTO (order_id,user_id,order_date,status)
VALUES
(1111,1,24-06-2024,pending),
(1112,2,25-06-2024,pending),
(1113,3,26-04-2024,success);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
	order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO (order_item_id, order_id, product_id, quantity, price)
VALUES
(987, 1111, 1234, 14, 12322113 )
(9876, 1112, 1704, 13, 1233432432)

SELECT * FROM Users;

SELECT * FROM Products WHERE seller_id = 101;

SELECT * FROM Orders;

SELECT * FROM Order_Items WHERE order_id = 1111;

SELECT u.user_id, u.name, u.email, u.phone, o.order_id, o.order_date, o.status
FROM Users u
JOIN Orders o ON u.user_id = o.user_id;

SELECT o.order_id, SUM(oi.price * oi.quantity) AS total_price
FROM Orders o
JOIN Order_Items oi ON o.order_id = p.product_id;


