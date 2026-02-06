
create table employee (
	ssn int primary key,
    name varchar(50),
    addrs varchar(100),
    sex varchar(6),
    salary int,
    superssn int,
    dno int,
    foreign key (superssn) references employee(ssn) on delete cascade
);

insert into employee values (1,'saiyedk9', 'Florida', 'Male', 85000, null, null);

create table dept (
	dno int primary key,
    dname varchar(50),
    mgrssn int,
    mgrdate date,
    foreign key (mgrssn) references employee(ssn) on delete cascade
);
-- refer dno from employee now
alter table employee
add constraint fk_dno
foreign key (dno) references dept(dno) on delete cascade;

insert into dept values (101, 'Cloud', 1, curdate());
-- updatee the employee table
update employee set dno = 101 where ssn = 1;


create table dloc (
	dno int,
    dloc varchar(100),
    primary key (dno, dloc),
    foreign key (dno) references dept(dno) on delete cascade
);

insert  into dloc values (101, "California");
use company;

create table project (
	pno int primary key,
    pname varchar(50),
    ploc varchar(50),
    dno int,
    foreign key (dno) references dept(dno)
);

insert into project values (1001, 'iot', 'Texas', 101);

create table workson (
	ssn int,
    pno int,
    hours int
);

insert into workson values (1,1001,36);

-- additonal addings to make the queries work
INSERT INTO dept VALUES
(5, 'Accounts', 1, CURDATE()),
(102, 'AI', 1, CURDATE()),
(103, 'HR', 1, CURDATE());
INSERT INTO dloc VALUES
(5, 'New York'),
(102, 'Seattle'),
(103, 'Chicago');
INSERT INTO employee VALUES
(2,'Michael Scott','Texas','Male',700000,1,5),
(3,'Alice Scott','California','Female',650000,1,5),
(4,'Robert Brown','Florida','Male',500000,1,5),
(5,'Nancy Drew','Nevada','Female',720000,1,5),
(6,'David Lee','Boston','Male',610000,1,5),
(7,'Chris Evans','Ohio','Male',450000,1,101),
(8,'Emma Stone','LA','Female',480000,1,102);
INSERT INTO project VALUES
(1002,'AI System','Seattle',102),
(1003,'HR Portal','Chicago',103),
(1004,'Accounts App','New York',5),
(1005,'CloudX','Texas',101);
INSERT INTO workson VALUES
(2,1001,30),
(3,1001,25),
(4,1004,40),
(5,1004,35),
(6,1005,20),
(7,1002,30),
(8,1003,28);

-- queries
-- 1. Make a list of all project numbers for projects that involve an employee whose last name 
-- is ‘Scott’, either as a worker or as a manager of the department that controls the project. 
select * from project where
dno in (select dno from employee where name like '%Scott')
or 
dno in (select dno from dept where mgrssn in (select ssn from employee where name like '%Scott'));

-- trick : in(emp) or in(dept in(emp))

select * from project where 
dno in (select dno from employee where name like '%Scott')
or 
dno in (select dno from dept where mgrssn in (select ssn from employee where name like '%scott'));

-- 2. Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 
-- percent raise. 
select * from employee;

update employee set salary = salary * 1.1
where ssn in (
	select ssn from workson join project using (pno)
    where pname = 'iot'
);

-- 3. Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the 
-- maximum salary, the minimum salary, and the average salary in this department. 
select sum(salary), max(salary), min(salary), avg(salary)
from employee join dept using (dno)
where dname = 'Accounts';
-- 4. Retrieve the name of each employee who works on all the projects controlled by 
-- department number 5 (use NOT EXISTS operator). 
-- trick E->P->W with p having 2 cond 1 being p.dno = 5 and other is the normal 
-- pno is the middle man like bid was for sailors
select e.name from employee e
where not exists(
	select p.pno from project p
    where p.dno = 5
    and not exists (
		select w.pno from workson w
        where w.pno = p.pno and w.ssn = e.ssn
    )
);

-- 5. For each department that has more than five employees, retrieve the department 
-- number and the number of its employees who are making more than Rs. 6,00,000. 

select d.dno as DeptNo, count(ssn) as NoOfEmployees
from dept d join employee using (dno)
where salary >= 600000
group by d.dno
having count(ssn) >= 5;

-- 6. Create a view that shows name, dept name and location of all employees. 
create or replace view EmployeeDept as
select e.name as empName, d.dname as deptName, dl.dloc as deptLocation from
employee e join dept d using (dno)
join dloc dl using (dno);

select * from EmployeeDept;

