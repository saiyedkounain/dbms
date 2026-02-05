-- Create sailor table
CREATE TABLE sailor (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    rating INT,
    age INT
);

-- Create boat table
CREATE TABLE boat (
    bid INT PRIMARY KEY,
    bname VARCHAR(50),
    color VARCHAR(50)
);

-- Create reserves table
CREATE TABLE reserves (
    sid INT,
    bid INT,
    date DATE,
    FOREIGN KEY (sid) REFERENCES sailor(sid),
    FOREIGN KEY (bid) REFERENCES boat(bid)
);

-- Insert sample data into sailor
INSERT INTO sailor VALUES
(1, 'Albert', 8, 41),
(2, 'Bob', 9, 45),
(3, 'Charlie', 9, 49),
(4, 'David', 8, 54),
(5, 'Eve', 7, 59);

-- Insert sample data into boat
INSERT INTO boat VALUES
(101, 'Boat1', 'Red'),
(102, 'Boat2', 'Blue'),
(103, 'Boat3', 'Green'),
(104, 'Boat4', 'Yellow'),
(105, 'Boat5', 'White');

-- Insert sample data into reserves
INSERT INTO reserves VALUES
(1, 101, '2023-01-01'),
(1, 102, '2023-02-01'),
(1, 103, '2023-03-01'),
(1, 104, '2023-04-01'),
(1, 105, '2023-05-01'),
(1, 101, '2023-01-01'),
(2, 101, '2023-02-01'),
(3, 101, '2023-03-01'),
(4, 101, '2023-04-01'),
(5, 101, '2023-05-01'),
(2, 102, '2023-02-01'),
(3, 103, '2023-03-01'),
(4, 104, '2023-04-01'),
(5, 105, '2023-05-01');

# Queries
#1. Colors of boats reserved by Albert
select b.color from boat b
join reserves r using (bid)
join sailor s using (sid)
where s.sname = 'albert';

#2 Sailor id with Rating 8 or have reserved boat 103
select distinct s.sid from sailor s
left join reserves r using (sid)
where s.rating >=8 or r.bid = 103; 

# Sailor Names who have NOT reserved a boat with name "storm"
select s.sname from sailor s 
where s.sid not in (
	select s.sid from sailor s 
    join reserves r using (sid)
    join boat b using (bid)
    where b.bname like "%storm%"
)
order by s.sname ASC; 

# 4 Sailor who has resereved all boats {NOT Exists}
# trick S -> B -> R : bid from B
select s.sname from sailor s 
where not exists (
	select b.bid from boat b
    where not exists(
		select r.bid from reserves r
        where r.sid = s.sid and r.bid = b.bid
    )
);
#5. Name and age of sailor who is the oldest
select s.sname, s.age from sailor s
order by s.age
limit 1;

# 6. For each boat that is reserved by 5 sailors of age >= 40, find i.boat id ii.avg age of sailors
#Trick is: start from Reserves table join Sailors and use Group BY and Having clause
select r.bid as boat_id, AVG(s.age) as avg_age from
reserves r 
join sailor s using (sid)
where s.age >= 40
group by r.bid
having COUNT(distinct r.sid) >=5; # be careful with having clause here

#7 View showing names and colors of all boats that have been reserved by a sailor with a specific rating '8'
create or replace view ReservedByRating AS
select b.bname, b.color 
from boat b 
join reserves r using (bid)
join sailor s using(sid)
where s.rating >=8;

#8. Trigger preventing to delete a boat if it has active reservations
DELIMITER //
CREATE TRIGGER preventDelete
BEFORE DELETE ON boat
FOR EACH ROW 
BEGIN
	IF(
		select count(*) from reserves where bid = OLD.bid
    ) > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cant delete';
    END IF;
END//
DELIMITER ;

#check
DELETE FROM boat
WHERE bid = 103;
