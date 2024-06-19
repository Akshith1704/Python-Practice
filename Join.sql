create database myntra;
use myntra;
create table products(
	pid int(4) primary key,
    pname varchar(17) not null,
    price int(11) not null,
    stock int(7),
    location varchar(30) check(location in ('Khammam','Wyra'))
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
create table employee(
	eid varchar(10),
    ename varchar(50)
);
create table projects(
	pid varchar(10),
    pname varchar(50),
    eid varchar(10)
);


--- Insert values
insert into products values(17,'shirt',3000,17,'Khammam');
insert into products values(04,'pant',1999,174,'Wyra');
insert into products values(71,'tshirt',1704,1740,'Khammam');
insert into products values(40,'hoodie',4017,1704,'Khammam');
insert into products values(174,'leggin',174,04,'Wyra');

select * from products;

insert into customer values(11,'Tej',17,'fdslfjl');
insert into customer values(12,'Navya',11,'fdslfjl');
insert into customer values(13,'Ammu',71,'fdslfjl');
insert into customer values(14,'Manu',18,'fdslfjl');
insert into customer values(15,'Akhi',18,'fdslfjl');


insert into orders values(1111,11,17,1704);
insert into orders values(1100,12,04,1800);
insert into orders values(1704,13,71,9000);
insert into orders values(1444,14,40,4600);
insert into orders values(1333,15,174,1700);

select * from orders;

insert into payment values(1,10001,2700,'upi','completed');
insert into payment values(2,10002,18000,'credit','completed');
insert into payment values(3,10003,900,'debit','in process');
insert into payment values(4,10004,46000,'upi','completed');
insert into payment values(5,10005,17000,'debit','pending');
select * from payment;

insert into employee values('D','Abhi');
insert into employee values('C','Bhargav');
insert into employee values('B','Teja');
insert into employee values('A','Lakshmi');

insert into projects values('P1','Web','A');
insert into projects values('P2','Power BI','B');
insert into projects values('P3','Sql','C');
insert into projects values('P4','Python',null);




-- INNER JOIN
select *
from employee
inner join projects on employee.eid = projects.eid;

-- LEFT JOIN
select *
from employee
left join projects on employee.eid = projects.eid;

-- RIGHT JOIN
select *
from employee
right join projects on employee.eid = projects.eid;

-- FULL JOIN
select *
from employee
left join projects on employee.eid = projects.eid
UNION
select *
from employee
right join projects on employee.eid = projects.eid;

-- CROSS JOIN
select *
from employee
cross join projects;



select *
from payment
inner join orders on payment.oid=orders.oid
left join products on orders.pid=products.pid;
'
select *
from orders
inner join products on orders.pid=products.pid
where location='Khammam';



select *
from orders
left join products on orders.pid=products.pid
where location='Wyra';

select *
from products;

select *
from products
right join orders on products.pid=orders.pid;

-- display details of all orders which were made by people below 30 years and delevired from "Delhi"
select * from orders 
left join products on orders.pid = products.pid
left join customer on orders.cid = customer.cid
where age<30 and location = "wyra";


-- display oid , amt  , customer name and payment mode of orders which were made by people below 30 years and payment was made through upi

select * from orders
left join customer on orders.cid = customer.cid
left join payment on orders.oid =  payment.oid
where age < 30 and mode = "upi";

-- display oid , amt , cname  , pname , location of orders whose payment is still pending or in process.sort the desending order of their amt.
select orders.oid , amt , cname , pname , location from orders
left join Payment on orders.oid =  Payment.oid
left join customer on orders.cid = customer.cid
left join products on orders.pid = products.pid     
where status in("in process" , "pending") order by orders.amt desc;



# aggigrate func = sum  , avg , count , min , max , prod , length
# group by = to see aggregate  function 
# where function does not work on aggrigate function instead it we use having by
-- i want to see location , average price and the no of products placed from various location
select location,count(*) , avg(price) from products
group by location;

-- display total transactions done through various mode of payment
select mode , sum(amount) from payment 
group  by mode;



-- display total amt of transactions done through various mode of payment where total amt >3000 and also sort in desc order of total amt

select mode  , sum(amount)  from payment
group by mode
having  sum(amount) > 3000
order by sum(amount) desc;

-- display total purchase made from various locations
select location , sum(amt) from orders 
inner join products on orders.pid = products.pid
group by location
having sum(amt) > 30000
order by sum(amt) desc;



/* 
SUBQUIRES
*/
-- avg order amount
select avg(amt) from orders ;



-- display more than avg amount

select * from orders 
where amt > 16500 ;
-- or by using subquire 
select * from orders
where amt >(select avg(amt) from orders);

-- dispaly details of customers whose age is greater than avg age of all customers;
select * from customer
where age > (select avg(age) from customer);

-- display details of products whose total amount is greater than 20000 ;

select pid  from orders
group by pid
having sum(amt) > 20000;


select * from products
where pid in (select pid  from orders
group by pid
having sum(amt) > 20000);
