CREATE DATABASE insurance;
USE insurance;

-- PERSON
CREATE TABLE IF NOT EXISTS person (
    driver_id VARCHAR(255) NOT NULL,
    driver_name TEXT NOT NULL,
    address TEXT NOT NULL,
    PRIMARY KEY (driver_id)
);

-- CAR
CREATE TABLE IF NOT EXISTS car (
    reg_no VARCHAR(255) NOT NULL,
    model TEXT NOT NULL,
    c_year INTEGER,
    PRIMARY KEY (reg_no)
);

-- ACCIDENT
CREATE TABLE IF NOT EXISTS accident (
    report_no INTEGER NOT NULL,
    accident_date DATE,
    location TEXT,
    PRIMARY KEY (report_no)
);

-- OWNS
CREATE TABLE IF NOT EXISTS owns (
    driver_id VARCHAR(255) NOT NULL,
    reg_no VARCHAR(255) NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (reg_no) REFERENCES car(reg_no) ON DELETE CASCADE
);

-- PARTICIPATED
CREATE TABLE IF NOT EXISTS participated (
    driver_id VARCHAR(255) NOT NULL,
    reg_no VARCHAR(255) NOT NULL,
    report_no INTEGER NOT NULL,
    damage_amount FLOAT NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (reg_no) REFERENCES car(reg_no) ON DELETE CASCADE,
    FOREIGN KEY (report_no) REFERENCES accident(report_no)
);

-- PERSON data
INSERT INTO person VALUES
("D111", "Driver_1", "Kuvempunagar, Mysuru"),
("D222", "Smith", "JP Nagar, Mysuru"),
("D333", "Driver_3", "Udaygiri, Mysuru"),
("D444", "Driver_4", "Rajivnagar, Mysuru"),
("D555", "Driver_5", "Vijayanagar, Mysore");

-- CAR data
INSERT INTO car VALUES
("KA-20-AB-4223", "Swift", 2020),
("KA-20-BC-5674", "Mazda", 2017),
("KA-21-AC-5473", "Alto", 2015),
("KA-21-BD-4728", "Triber", 2019),
("KA-09-MA-1234", "Tiago", 2018);

-- ACCIDENT data
INSERT INTO accident VALUES
(43627, "2020-04-05", "Nazarbad, Mysuru"),
(56345, "2019-12-16", "Gokulam, Mysuru"),
(63744, "2020-05-14", "Vijaynagar, Mysuru"),
(54634, "2019-08-30", "Kuvempunagar, Mysuru"),
(65738, "2021-01-21", "JSS Layout, Mysuru"),
(66666, "2021-01-21", "JSS Layout, Mysuru"),
(45562, "2024-04-05", "Mandya"),
(49999, "2024-04-05", "Kolkata");

-- OWNS data
INSERT INTO owns VALUES
("D111", "KA-20-AB-4223"),
("D222", "KA-20-BC-5674"),
("D333", "KA-21-AC-5473"),
("D444", "KA-21-BD-4728"),
("D222", "KA-09-MA-1234");

-- PARTICIPATED data
INSERT INTO participated VALUES
("D111", "KA-20-AB-4223", 43627, 20000),
("D222", "KA-20-BC-5674", 56345, 49500),
("D333", "KA-21-AC-5473", 63744, 15000),
("D444", "KA-21-BD-4728", 54634, 5000),
("D222", "KA-09-MA-1234", 65738, 25000),
("D222", "KA-21-BD-4728", 45562, 50000),
("D222", "KA-21-BD-4728", 49999, 50000);


#Queries

#1. Find the number of people who owned cars that were involved in accidents in 2021

select count(*) from person 
join participated using (driver_id)
join accident using (report_no)
where year(accident_date) = '2021';

#2 Find the number of accidents in which cars belongin to Smith were involved
select count(*) from accident
join participated using (report_no)
join person using (driver_id)
where driver_name = 'Smith';


#3. Add a new accident to the database; assume any values for required attributes. 
# do it yourself : just add owns and participated 

#4. Delete the Mazda belonging to “Smith”. 
	-- careful u might have to do this
	SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 0;
Delete from car
where model = 'Mazda' AND reg_no in (
	select reg_no from owns join person using (driver_id)
    where driver_name = 'Smith'
);

#5. Update the damage amount for the car with license number “KA09MA1234” in the accident with report. 
update participated
set damage_amount = 50000
where reg_no = 'KA-09-MA-1234';

SELECT * FROM participated;


#6. A view that shows models and year of cars that are involved in accident. 
create or replace view acccars2 as
select c.model as model, c.c_year as year 
from car c join participated p using (reg_no);

#7. A trigger that prevents a driver from participating in more than 3 accidents in a given year.

delimiter //
create trigger ppp2
before insert on participated
for each row
begin
	if(select count(*) from participated p where p.driver_id=NEW.driver_id) >= 3 then
    signal sqlstate '45000'
    set message_text = 'already been in 2 accidents';
    end if;
end
//
delimiter ;
