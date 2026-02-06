CREATE DATABASE order_processing;
USE order_processing;

-- customer
CREATE TABLE customer (
    cust INT PRIMARY KEY,
    cname VARCHAR(100),
    city VARCHAR(100)
);

-- order_
CREATE TABLE order_ (
    order_ INT PRIMARY KEY,
    odate DATE,
    cust INT,
    order_amt INT,
    FOREIGN KEY (cust) REFERENCES customer(cust) ON DELETE CASCADE
);

-- item
CREATE TABLE item (
    item INT PRIMARY KEY,
    unitprice INT
);

-- orderitem
CREATE TABLE orderitem (
    order_ INT,
    item INT,
    qty INT,
    FOREIGN KEY (order_) REFERENCES order_(order_) ON DELETE CASCADE,
    FOREIGN KEY (item) REFERENCES item(item) ON DELETE CASCADE
);

-- warehouse
CREATE TABLE warehouse (
    warehouse INT PRIMARY KEY,
    city VARCHAR(100)
);

-- shipment
CREATE TABLE shipment (
    order_ INT,
    warehouse INT,
    ship_date DATE,
    FOREIGN KEY (order_) REFERENCES order_(order_) ON DELETE CASCADE,
    FOREIGN KEY (warehouse) REFERENCES warehouse(warehouse) ON DELETE CASCADE
);


-- Data insertion

INSERT INTO customer VALUES
(101, 'Kumar', 'City1'),
(102, 'Peter', 'City2'),
(103, 'James', 'City3'),
(104, 'Kevin', 'City4'),
(105, 'Harry', 'City5');

INSERT INTO order_ VALUES
(201, '2023-04-11', 101, 1567),
(202, '2023-04-12', 102, 2567),
(203, '2023-04-13', 103, 3567),
(204, '2023-04-14', 104, 4567),
(205, '2023-04-15', 105, 5567);

INSERT INTO item VALUES
(1001, 100),
(1002, 200),
(1003, 300),
(1004, 400),
(1005, 500);

INSERT INTO orderitem VALUES
(201,1001,10),
(202,1002,11),
(203,1003,12),
(204,1004,13),
(205,1005,14);

INSERT INTO warehouse VALUES
(1, 'Wcity1'),
(2, 'Wcity2'),
(3, 'Wcity3'),
(4, 'Wcity4'),
(5, 'Wcity5');

INSERT INTO shipment VALUES
(201, 1, '2023-05-01'),
(202, 2, '2023-05-02'),
(203, 3, '2023-05-03'),
(204, 4, '2023-05-04'),
(205, 5, '2023-05-05');


# Queries
#1. List the Order# and Ship_date for all orders shipped from Warehouse# "W2". 

select o.order_ , s.ship_date from 
order_ o join shipment s using (order_)
where s.warehouse = 2;

#2. List the Warehouse information from which the Customer named "Kumar" was supplied his 
# orders. Produce a listing of Order#, Warehouse#. 
select order_ , warehouse from shipment
join order_ using (order_)
join customer using (cust)
where customer.cname = 'Kumar';

#3. Produce a listing: Cname, #ofOrders, Avg_Order_Amt, where the middle column is the total 
#number of orders by the customer and the last column is the average order amount for that 
#customer. (Use aggregate functions) 
select cname as CustmoerName, Count(order_) as NoOfOrdes, AVG(order_amt) as avgOrderAmt
from customer join order_ using (cust)
group by cname;
# whenever u use any aggreagrate func also use group by


#4. Delete all orders for customer named "Kumar". 
delete from order_
where cust in (select cust from customer where cname = 'Kumar');

select * from order_;
select * from customer;

#5. Find the item with the maximum unit price. 
select item, unitprice from item
order by unitprice desc
limit 1;

#6. A trigger that updates order_amout based on quantity and unitprice of order_item
DELIMITER //
CREATE TRIGGER update_order_amount
BEFORE INSERT ON OrderItem
FOR EACH ROW
BEGIN
    UPDATE Order_
    SET order_amt = NEW.qty *(SELECT unitprice FROM Item WHERE item = NEW.item)
    WHERE order_ = NEW.order_;
END ;
//
DELIMiTEr ;
#7. Create a view to display orderID and shipment date of all orders shipped from a warehouse
create or replace view W5Orders as
select o.order_ , s.ship_date from 
order_ o join shipment s using (order_)
where s.warehouse = 5;

select * from W5Orders;
