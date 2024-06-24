create database meesho;
use meesho;
create table products(
	pid int(4) primary key,
    pname varchar(17) not null,
    price int(17) not null,
    stock int(4),
    location varchar(17) check(location in ('Khammam','Wyra'))
);
create table customer(
	cid int(4) primary key,
    cname varchar(17) not null,
    age int(4),
    addr varchar(174)
);
create table orders(
	oid int(4) primary key,
    cid int(4),
    pid int(4),
    amt int(17) not null,
    foreign key(cid) references customer(cid),
    foreign key(pid) references products(pid)
);
create table payment(
	pay_id int(4) primary key,
    oid int(4),
    amount int(17) not null,
    mode varchar(30) check(mode in('upi','credit','debit')),
    status varchar(30),
    foreign key(oid) references orders(oid)
);

#Inserting values into products table
insert into products values(1,'Tshirt',5000,17,'Wyra');
insert into products values(2,'Shirt',2000,10,'Wyra');
insert into products values(3,'Pant',3000,20,'Khammam');


#Inserting values into customer table
insert into customer (cid, cname, age, addr) values
(11,'Manu',18,'aaaaaaa'),
(12,'Akhi',18,'bbbbbb'),
(13,'Tej',17,'ccccccccc'),

#Inserting values into orders table
insert into orders values(111,11,1,2700);
insert into orders values(122,12,2,18000);
insert into orders values(133,13,3,900);

#inserting values into payments table
insert into payment values(12,111,2700,'upi','completed');
insert into payment values(21,122,18000,'credit','completed');
insert into payment values(31,133,900,'debit','in process');

UPDATE payment
SET timestamp = '2024-07-21 17:04:00'
WHERE pay_id = 1;
UPDATE payment
SET timestamp = '2024-07-21 17:05:00'
WHERE pay_id = 2;
UPDATE payment
SET timestamp = '2024-07-21 17:06:00'
WHERE pay_id = 3;


/*
--> Subqueries	
		Single row subqueries
		Multi row subqueries
		Correlated subqueries queries
--> Joins	
		Joins with subqueries
		Joins with aggregate functions
		Joins with date and time functions
--> Analytics functions / Advanced functions	
		RANK
		DENSE_RANK
		ROW_NUMBER
		CUME_DIST
		LAG
		LEAD
*/

-- SUBQUERIES:-

-- SINGLE ROW SUBQUERIES:Find customer who placed the highest order amount

select cname from customer 
where cid=(select cid   
from orders 
order by amt 
desc limit 1);

-- SINGLE ROW SUBQUERIES: Find the product with the highest price
select pname from products 
where price=(select max(price) from products);

-- MULTIPLE-ROW SUBQUERIES
-- MULTIPLE-ROW SUBQUERIES: Find all customers who have placed an order
SELECT cname
FROM customer
WHERE cid IN (SELECT cid
FROM orders);

-- MULTIPLE-ROW SUBQUERIES: Find all customers who have placed an order for a product from Mumbai
SELECT cname
FROM customer
WHERE cid IN (SELECT cid FROM orders
WHERE pid IN (SELECT pid FROM products WHERE location = 'Wyra'));

-- CORRELATED SUBQUERIES

-- CORRELATED SUBQUERIES: Products with Price Higher than Location Average
SELECT pname, price
FROM products p
WHERE price > (
    SELECT AVG(price)
    FROM products
    WHERE location = p.location
);

-- CORRELATED SUBQUERIES: Customers with Orders Exceeding Average Order Amount
SELECT cname
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.cid = c.cid
    GROUP BY o.cid
    HAVING AVG(o.amt) > (
        SELECT AVG(amt)
        FROM orders
    )
);


-- JOINS

-- Inner join with subquery

SELECT p.pname, o.oid, o.amt
FROM products p
INNER JOIN (
    SELECT *
    FROM orders
) o ON p.pid = o.pid
WHERE p.price > 1000;
-- Left join with aggregate function

SELECT p.pname, SUM(o.amt) AS total_orders_amount
FROM products p
LEFT JOIN orders o ON p.pid = o.pid
GROUP BY p.pname;

-- Right join with date and time functions

SELECT o.oid, o.amt, p.status, p.timestamp
FROM orders o
RIGHT JOIN payment p ON o.oid = p.oid;

-- Analytics functions / Advanced functions

-- RANK: Rank of products by price

SELECT pid, pname, price, RANK() OVER (ORDER BY price DESC) AS price_rank
FROM products;

-- DENSE_RANK: Dense rank of products by price

SELECT pid, pname, price, 
	DENSE_RANK() OVER (ORDER BY price DESC) AS price_rank
FROM products;

-- ROW_NUMBER: Unique row number of customers by age

SELECT ROW_NUMBER() OVER (ORDER BY age DESC) AS row_num, cid, cname, age, addr
FROM customer;

-- CUME_DIST: Cumulative distribution of payment amounts

SELECT oid, amount,
       CUME_DIST() OVER (ORDER BY amount) AS cumulative_distribution
FROM payment;


-- LAG: Previous price of products by location

SELECT pname, price, location,LAG(price) OVER (PARTITION BY location ORDER BY price) AS lag_price
FROM products;


-- LEAD: Next price of products by location

SELECT pname, price, location,LEAD(price) OVER (PARTITION BY location ORDER BY price) AS lead_price
FROM products;
