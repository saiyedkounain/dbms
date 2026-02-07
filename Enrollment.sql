create table student (
	regno varchar(50) primary key,
    name varchar(50),
    major varchar(50),
    bdate date
);
insert into student values ('s2','zulfi','cse','2005-01-01');

create table course (
	course_ int primary key,
    cname varchar(50),
    dept varchar(50)
);
insert into course values (1,'dbms','cse');

create table enroll (
	regno varchar(50),
    course_ int,
    sem int,
    marks int,
    primary key(regno, course_),
    foreign key (regno) references student(regno),
    foreign key (course_) references course(course_)
);
insert into enroll values('s1',1,5,96);

create table textB (
	bookISBN int primary key,
    bookTitle varchar(50),
    publisher varchar(50),
    author varchar(50)
);

insert into textB values (1001,'DBMS by Navathe', 'Sri Publishers', 'Adam & Navathe');

create table bookAdp (
	course_ int,
    sem int,
    bookISBN int,
    primary key (course_, bookISBN),
    foreign key (course_) references course(course_),
	foreign key (bookISBN) references textB(bookISBN)
);

insert into bookAdp values (1,5,1001);

-- queries

-- 1 demo how u add a new textbook and make this book be adopted by some department
insert into textb values (1002,'CN by Elgamal', 'Saiyed Publishers', 'Ibn Qaasim');
-- adding to dept
insert into course values (2,'cn','cse');
-- adopting it 
insert into bookAdp values (2,5,1002);

-- 2 Produce a list of textbooks (include course_ , bookISBN, bookTitle) in alpha order 
-- for the courses offered by the cse department that use more than 2 books

select c.course_, b.bookISBN, b.bookTitle
from course c join bookAdp using(course_)
join textb b using (bookISBN)
where c.dept = 'cse'
and course_ in (
	select course_ from bookAdp
    group by course_
    having count(*) >= 2
)
order by bookTitle ASC;

-- 3. List any department that has all its adopted books published by a specific publisher.
-- trick dept IN() and NOT IN()

select distinct dept from course 
where dept IN (
	select dept from course join bookAdp using (course_) join textB using (bookISBN)
    where publisher = 'Civil Publishers'
) AND dept NOT IN (
	select dept from course join bookAdp using (course_) join textB using (bookISBN)
    where publisher != 'Civil Publishers'
);

-- 4. List the students who have scored maximum marks in ‘DBMS’ course. 
select s.name, c.cname , e.marks from
student s join enroll e using (regno) join course c using (course_)
order by e.marks desc
limit 1;

--  5. Create a view to display all the courses opted by a student along with marks obtained.
create or replace view Marks as
select s.regno as RegNo, s.name as Name, c.cname as Course , e.marks as Marks_Obtained 
from student s join enroll e using(regno) join course c using (course_);

select * from Marks;
