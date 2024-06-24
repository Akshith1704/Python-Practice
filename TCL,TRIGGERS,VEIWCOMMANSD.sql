e database meesho;
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

-- TCL (Transaction control language) Commands
/*
TCL commands are used to manage transactions, maintain ACID properties, and control the flow of data modifications.
TCL commands ensure the consistency and durability of data in a database.
For example, if an operation fails during a transaction, the transaction is rolled back.
When a transaction is committed, its changes are permanent, even if the system fails or restarts.
TCL commands also ensure that all operations within a transaction are executed as a single unit.
*/

-- commit
/*
Commit: Saves a transaction to the database
*/
commit;
-- rollback
/*
Rollback: Undoes a transaction or change that hasn't been saved to the database
*/
rollback;

-- savepoint
/*
Savepoint: Temporarily saves a transaction for later rollback 
*/
savepoint a;
-- here it will store that as a
-- after we can call that by rollback to a
rollback to a;

-- any operation performed on table using dml
-- insert,delete,update every command is transaction 

/*
In mysql it is having auto commit so is doesnot make anysense transaction commands in mysql
for this we have to use command start transaction
*/

-- Triggers 

-- Trigger is a statement that a system executes automatically when there is any modification to the database
-- Triggers are used to specify certain integrity constraints and referential constraints that cannot be specified using the constraint mechanism of SQL

-- Trigers are 6 types 
/*
1)after insert -- activated after data is inserted into the table.
2)after update -- activated after data in the table is modified. 
3)after delete -- activated after data is deleted/removed from the table. 
4)before insert -- activated before data is inserted into the table. 
5)before update -- activated before data in the table is modified.
6)before delete --  activated before data is deleted/removed from the table. 
*/
-- Delimiters are necessary when creating stored procedures or triggers
-- Delimiters are used in MySQL to avoid conflicts with semicolons within SQL statements

-- "SQL Trigger for Logging Product Insertions"
-- after insert
DELIMITER //
CREATE TRIGGER products_after_insert
AFTER INSERT ON products
FOR EACH ROW
BEGIN
  INSERT INTO product_log (pid, pname, price, stock, location, inserted_at)
  VALUES (NEW.pid, NEW.pname, NEW.price, NEW.stock, NEW.location, NOW());
END //
DELIMITER ;

-- create an SQL trigger to automatically update product stock levels after each new order is inserted into the 'orders' table?
DELIMITER //
CREATE TRIGGER orders_after_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock = stock - 1
  WHERE pid = NEW.pid;
END //
DELIMITER ;


-- after update 

-- SQL trigger to log changes made to product information whenever an update occurs in the 'products' table?
DELIMITER //
CREATE TRIGGER products_after_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
  IF OLD.pid <> NEW.pid OR OLD.pname <> NEW.pname OR OLD.price <> NEW.price OR OLD.stock <> NEW.stock OR OLD.location <> NEW.location THEN
    INSERT INTO product_log (pid, pname, price, stock, location, updated_at)
    VALUES (OLD.pid, OLD.pname, OLD.price, OLD.stock, OLD.location, NOW());
  END IF;
END //
DELIMITER ;


-- after delete 

-- SQL trigger to prevent the deletion of a product from the 'products' table if there are existing orders referencing that product in the 'orders' table?
DELIMITER //
CREATE TRIGGER products_after_delete
AFTER DELETE ON products
FOR EACH ROW
BEGIN
  -- Log information about deleted product (optional)
  -- INSERT INTO product_log (pid, pname, price, stock, location, deleted_at)
  -- VALUES (OLD.pid, OLD.pname, OLD.price, OLD.stock, OLD.location, NOW());

  -- Check if there are existing orders referencing the deleted product
  DECLARE has_orders INT DEFAULT (0);

  SELECT COUNT(*) INTO has_orders
  FROM orders
  WHERE pid = OLD.pid;

  IF has_orders > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete product with existing orders. Update or delete orders first.';
  END IF;
END //
DELIMITER ;

-- before insert

#Trigger for Automatic Payment Status on Payment Insert
DELIMITER //

CREATE TRIGGER set_default_payment_status
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
  IF NEW.status IS NULL THEN
    SET NEW.status = 'Pending';
  END IF;
END //

DELIMITER ;