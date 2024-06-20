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
drop table products ;
drop database meesho;
alter table customer
add phone varchar(17); 
alter table customer
drop column phone;
 alter table orders
rename column amt to amount ;
alter table products
modify column price varchar(17) ;
alter table products
modify column location varchar(17) check(location in ('Khammam','Wyra' , 'Hyderabad')) ;
truncate table products ;
alter table customer
modify column age int(4) not null;
alter table customer
modify column phone varchar(17) unique ;

alter table payment
modify column status varchar(17) check( status in ('pending' , 'cancelled' , 'completed'));

alter table products
modify column location varchar(17) default 'Khammam' check(location in ('Khammam','Wyra' , 'Hyderabad')) ;

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
;


#inserting values into payments table
insert into payment values(12,111,2700,'upi','completed');
insert into payment values(21,122,18000,'credit','completed');
insert into payment values(31,133,900,'debit','in process');

update product
set locaiton = 'Khammam'
where pname = 'Pant' ;

delete from customer
where cname = 'Akhi';




/* 
QUESTIONS
-- 0)Make a new table employee with specified column id, name, position and salary.
-- 1)insert query adds a new row to the employees table with specific values for id, name, position, and salary.
-- 2)update query updates the salary of the employee with id = 1.
-- 3)delete query deletes the row from employees where id = 1.
-- 4)create a query that creates a table called students.
-- 5)create another table courses and set up a foreign key constraint in the students table.
	The foreign key constraint ensures that the course_id in students must refer to a valid course_id in the courses table.
-- 6)Alter the students table to add the foreign key constraint.
-- 7)insert some data into the students table while respecting the constraints.
-- 8)create a SELECT query that retrieves products based on numeric and date conditions.
-- 9)update a record and set the last_updated column to the current datetime.
-- 10)delete products with stock below a certain threshold.
*/







--  insert  query adds a new row to the employees table with specific values for id, name, position, and salary.
INSERT INTO employees (id, name, position, salary)
VALUES (1, 'Akshith', 'Software Engineer', 175000);

-- update query updates the salary of the employee with id = 1.
UPDATE employees
SET salary = 8000
WHERE id = 1;

-- delete query deletes the row from employees where id = 1.
DELETE FROM employees
WHERE id = 1;

--  create a query that creates a table called students with various constraints.
CREATE TABLE students (
  student_id INT PRIMARY KEY,       
  name VARCHAR(100) NOT NULL,        
  email VARCHAR(100) UNIQUE,       
  age INT CHECK (age >= 18),        
  course_id INT,                    
  grade CHAR(1) DEFAULT 'F'          
);

-- create another table courses and set up a foreign key constraint in the students table. 
-- The foreign key constraint ensures that the course_id in students must refer to a valid course_id in the courses table.
CREATE TABLE courses (
  course_id INT PRIMARY KEY,          
  course_name VARCHAR(100) NOT NULL   
);

-- Alter the students table to add the foreign key constraint
ALTER TABLE students
ADD CONSTRAINT fk_course
FOREIGN KEY (course_id)
REFERENCES courses (course_id)
ON DELETE CASCADE;  -- If a course is deleted, all related students are also deleted

--  insert some data into the students table while respecting the constraints.

INSERT INTO students (student_id, name, email, age, course_id, grade)
VALUES (1, 'Akshith', 'akshith.com', 21, 1001, 'A');  

-- This will fail because 'student_id' is not unique
INSERT INTO students (student_id, name, email, age, course_id, grade)
VALUES (2, 'Teja', 'teja.com', 22, 1002, 'B');  

-- This will also fail because 'name' has a NOT NULL constraint
INSERT INTO students (student_id, email, age, course_id, grade)
VALUES (3, 'manu.com', 19, 133, 'B'); 

-- This will fail because 'age' doesn't meet the CHECK constraint
INSERT INTO students (student_id, name, email, age, course_id, grade)
VALUES (4, 'David Brown', 'david@example.com', 16, 104, 'C');  

--  create a SELECT query that retrieves products based on numeric and date conditions.
-- Retrieve products with a price greater than 100 and released after January 1, 2022
SELECT * 
FROM products 
WHERE price > 100 AND release_date > '2022-01-01';

--   update a record and set the last_updated column to the current datetime.
-- Update product details and set the last_updated to the current timestamp
UPDATE products
SET price = 1100.00, last_updated = NOW()  
WHERE product_id = 1;

-- delete products with stock below a certain threshold.
-- Delete products with stock below 100
DELETE FROM products 
WHERE stock < 100;
