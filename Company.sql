/* ============================================================
   COMPANY DATABASE – SCHEMA + SAMPLE DATA + ALL EXAMPLES
   ============================================================ */

---------------------------------------------------------------
-- 1. DROP TABLES (if your DB supports this syntax)
---------------------------------------------------------------
DROP TABLE IF EXISTS WORKS_ON;
DROP TABLE IF EXISTS DEPENDENT;
DROP TABLE IF EXISTS PROJECT;
DROP TABLE IF EXISTS DEPT_LOCATIONS;
DROP TABLE IF EXISTS DEPARTMENT;
DROP TABLE IF EXISTS EMPLOYEE;

---------------------------------------------------------------
-- 2. TABLE DEFINITIONS (short versions)
---------------------------------------------------------------

CREATE TABLE EMPLOYEE (
  FNAME    VARCHAR(15) NOT NULL,
  MINIT    CHAR(1),
  LNAME    VARCHAR(15) NOT NULL,
  SSN      CHAR(9)     NOT NULL,
  BDATE    DATE,
  ADDRESS  VARCHAR(40),
  SEX      CHAR(1),
  SALARY   DECIMAL(10,2),
  SUPERSSN CHAR(9),
  DNO      INT         NOT NULL,
  PRIMARY KEY (SSN)
);

CREATE TABLE DEPARTMENT (
  DNAME        VARCHAR(15) NOT NULL,
  DNUMBER      INT         NOT NULL,
  MGRSSN       CHAR(9)     NOT NULL,
  MGRSTARTDATE DATE,
  PRIMARY KEY (DNUMBER),
  UNIQUE (DNAME)
);

CREATE TABLE DEPT_LOCATIONS (
  DNUMBER   INT         NOT NULL,
  DLOCATION VARCHAR(15) NOT NULL,
  PRIMARY KEY (DNUMBER, DLOCATION)
);

CREATE TABLE PROJECT (
  PNAME    VARCHAR(15) NOT NULL,
  PNUMBER  INT         NOT NULL,
  PLOCATION VARCHAR(15),
  DNUM     INT         NOT NULL,
  PRIMARY KEY (PNUMBER),
  UNIQUE (PNAME)
);

CREATE TABLE WORKS_ON (
  ESSN  CHAR(9)      NOT NULL,
  PNO   INT          NOT NULL,
  HOURS DECIMAL(4,1),
  PRIMARY KEY (ESSN, PNO)
);

CREATE TABLE DEPENDENT (
  ESSN           CHAR(9)     NOT NULL,
  DEPENDENT_NAME VARCHAR(15) NOT NULL,
  SEX            CHAR(1),
  BDATE          DATE,
  RELATIONSHIP   VARCHAR(10),
  PRIMARY KEY (ESSN, DEPENDENT_NAME)
);

---------------------------------------------------------------
-- 3. SAMPLE DATA FOR THE STATE SHOWN IN THE IMAGE
---------------------------------------------------------------

-- EMPLOYEE
INSERT INTO EMPLOYEE VALUES
('John'    ,'B','Smith'  ,'123456789','1965-01-09','731 Fondren, Houston, TX','M',30000, '333445555',5),
('Franklin','T','Wong'   ,'333445555','1955-12-08','638 Voss, Houston, TX'   ,'M',40000, '888665555',5),
('Alicia'  ,'J','Zelaya' ,'999887777','1968-07-19','3321 Castle, Spring, TX','F',25000, '987654321',4),
('Jennifer','S','Wallace','987654321','1941-06-20','291 Berry, Bellaire, TX','F',43000, '888665555',4),
('Ramesh'  ,'K','Narayan','666884444','1962-09-15','975 Fire Oak, Humble, TX','M',38000,'333445555',5),
('Joyce'   ,'A','English','453453453','1972-07-31','5631 Rice, Houston, TX','F',25000,'333445555',5),
('Ahmad'   ,'V','Jabbar' ,'987987987','1969-03-29','980 Dallas, Houston, TX','M',25000,'987654321',4),
('James'   ,'E','Borg'   ,'888665555','1937-11-10','450 Stone, Houston, TX','M',55000, NULL,1);

-- DEPARTMENT
INSERT INTO DEPARTMENT VALUES
('Research'      ,5,'333445555','1988-05-22'),
('Administration',4,'987654321','1995-01-01'),
('Headquarters'  ,1,'888665555','1981-06-19');

-- DEPT_LOCATIONS
INSERT INTO DEPT_LOCATIONS VALUES
(1,'Houston'),
(4,'Stafford'),
(5,'Bellaire'),
(5,'Sugarland'),
(5,'Houston');

-- PROJECT
INSERT INTO PROJECT VALUES
('ProductX'      , 1,'Bellaire',5),
('ProductY'      , 2,'Sugarland',5),
('ProductZ'      , 3,'Houston',5),
('Computerization',10,'Stafford',4),
('Reorganization',20,'Houston',1),
('Newbenefits'   ,30,'Stafford',4);

-- WORKS_ON
INSERT INTO WORKS_ON VALUES
('123456789', 1,32.5),
('123456789', 2, 7.5),
('666884444', 3,40.0),
('453453453', 1,20.0),
('453453453', 2,20.0),
('333445555', 2,10.0),
('333445555', 3,10.0),
('333445555',10,10.0),
('333445555',20,10.0),
('999887777',30,30.0),
('999887777',10,10.0),
('987987987',10,35.0),
('987987987',30, 5.0),
('987654321',30,20.0),
('987654321',20,15.0),
('888665555',20, NULL);

-- DEPENDENT
INSERT INTO DEPENDENT VALUES
('333445555','Alice'    ,'F','1986-04-05','DAUGHTER'),
('333445555','Theodore' ,'M','1983-10-25','SON'),
('333445555','Joy'      ,'F','1958-05-03','SPOUSE'),
('987654321','Abner'    ,'M','1942-02-28','SPOUSE'),
('123456789','Michael'  ,'M','1988-01-04','SON'),
('123456789','Alice'    ,'F','1988-12-30','DAUGHTER'),
('123456789','Elizabeth','F','1967-05-05','SPOUSE');

---------------------------------------------------------------
-- 4. EXAMPLE QUERIES (QUESTIONS AS COMMENTS)
---------------------------------------------------------------

-- Q0: Birthdate and address of the employee named 'John B. Smith'.
SELECT BDATE, ADDRESS
FROM EMPLOYEE
WHERE FNAME = 'John' AND MINIT = 'B' AND LNAME = 'Smith';

-- Q1: Name and address of employees who work for the 'Research' department.
SELECT E.FNAME, E.LNAME, E.ADDRESS
FROM EMPLOYEE E, DEPARTMENT D
WHERE D.DNAME = 'Research' AND D.DNUMBER = E.DNO;

-- Q2: For projects in 'Stafford', list project#, dept#, and manager's name, birthdate, and address.
SELECT P.PNUMBER, P.DNUM, E.LNAME, E.BDATE, E.ADDRESS
FROM PROJECT P, DEPARTMENT D, EMPLOYEE E
WHERE P.DNUM = D.DNUMBER
  AND D.MGRSSN = E.SSN
  AND P.PLOCATION = 'Stafford';

-- Q8: For each employee, retrieve their name and the name of their immediate supervisor.
SELECT E.FNAME, E.LNAME, S.FNAME, S.LNAME
FROM EMPLOYEE E, EMPLOYEE S
WHERE E.SUPERSSN = S.SSN;

-- Q9: Retrieve the SSN values for all employees.
SELECT SSN FROM EMPLOYEE;

-- Q10: Example Cartesian product of EMPLOYEE and DEPARTMENT.
SELECT SSN, DNAME
FROM EMPLOYEE, DEPARTMENT;

-- Q1C: All attributes of employees in department 5.
SELECT *
FROM EMPLOYEE
WHERE DNO = 5;

-- Q1D: All attributes of employees in the 'Research' department.
SELECT *
FROM EMPLOYEE E, DEPARTMENT D
WHERE D.DNAME = 'Research' AND E.DNO = D.DNUMBER;

-- Q11: Retrieve all salary values of employees.
SELECT SALARY
FROM EMPLOYEE;

-- Q11A: Retrieve all distinct salary values of employees.
SELECT DISTINCT SALARY
FROM EMPLOYEE;

-- Q4: Project names involving an employee named 'Smith' (as worker or manager).
(SELECT P.PNAME
 FROM PROJECT P, DEPARTMENT D, EMPLOYEE E
 WHERE P.DNUM = D.DNUMBER
   AND D.MGRSSN = E.SSN
   AND E.LNAME = 'Smith')
UNION
(SELECT P.PNAME
 FROM PROJECT P, WORKS_ON W, EMPLOYEE E
 WHERE P.PNUMBER = W.PNO
   AND W.ESSN = E.SSN
   AND E.LNAME = 'Smith');

-- Q1 (nested): Name and address of employees who work for 'Research' (using subquery).
SELECT FNAME, LNAME, ADDRESS
FROM EMPLOYEE
WHERE DNO IN (
  SELECT DNUMBER
  FROM DEPARTMENT
  WHERE DNAME = 'Research'
);

-- Q12: Employees who have a dependent with the same first name.
SELECT E.FNAME, E.LNAME
FROM EMPLOYEE E
WHERE E.SSN IN (
  SELECT D.ESSN
  FROM DEPENDENT D
  WHERE D.ESSN = E.SSN
    AND E.FNAME = D.DEPENDENT_NAME
);

-- Q12B (EXISTS version): Employees who have a dependent with the same first name.
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE EXISTS (
  SELECT *
  FROM DEPENDENT
  WHERE SSN = ESSN
    AND FNAME = DEPENDENT_NAME
);

-- Q6: Employees who have no dependents.
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE NOT EXISTS (
  SELECT *
  FROM DEPENDENT
  WHERE SSN = ESSN
);

-- Q13: SSNs of employees who work on project 1, 2, or 3.
SELECT DISTINCT ESSN
FROM WORKS_ON
WHERE PNO IN (1,2,3);

-- Q14: Employees who do not have supervisors.
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE SUPERSSN IS NULL;

-- Q14 (renamed columns): Same query but with new headings.
SELECT FNAME AS FIRST_NAME, LNAME AS LAST_NAME
FROM EMPLOYEE
WHERE SUPERSSN IS NULL;

-- Q1 (join style): Name and address of employees who work for 'Research' using join.
SELECT FNAME, LNAME, ADDRESS
FROM EMPLOYEE JOIN DEPARTMENT ON DNUMBER = DNO
WHERE DNAME = 'Research';

-- Q2 (join style): Q2 using joined tables.
SELECT PNUMBER, DNUM, LNAME, BDATE, ADDRESS
FROM (PROJECT JOIN DEPARTMENT ON DNUM = DNUMBER)
     JOIN EMPLOYEE ON MGRSSN = SSN
WHERE PLOCATION = 'Stafford';

-- Q15: Max, min, and average salary of all employees.
SELECT MAX(SALARY), MIN(SALARY), AVG(SALARY)
FROM EMPLOYEE;

-- Q16: Max, min, and average salary among employees in 'Research'.
SELECT MAX(SALARY), MIN(SALARY), AVG(SALARY)
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DNO = D.DNUMBER
  AND D.DNAME = 'Research';

-- Q17: Total number of employees in the company.
SELECT COUNT(*)
FROM EMPLOYEE;

-- Q18: Number of employees in the 'Research' department.
SELECT COUNT(*)
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DNO = D.DNUMBER
  AND D.DNAME = 'Research';

-- Q20: For each department, department number, employee count, and average salary.
SELECT DNO, COUNT(*), AVG(SALARY)
FROM EMPLOYEE
GROUP BY DNO;

-- Q21: For each project, project number, name, and number of workers.
SELECT P.PNUMBER, P.PNAME, COUNT(*)
FROM PROJECT P, WORKS_ON W
WHERE P.PNUMBER = W.PNO
GROUP BY P.PNUMBER, P.PNAME;

-- Q22: Projects on which more than two employees work.
SELECT P.PNUMBER, P.PNAME, COUNT(*)
FROM PROJECT P, WORKS_ON W
WHERE P.PNUMBER = W.PNO
GROUP BY P.PNUMBER, P.PNAME
HAVING COUNT(*) > 2;

-- Q23: Employees who have at least 2 dependents.
SELECT LNAME, FNAME
FROM EMPLOYEE
WHERE (SELECT COUNT(*)
       FROM DEPENDENT
       WHERE SSN = ESSN) >= 2;

-- Q25: Employees whose address is in 'Houston,TX'.
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE ADDRESS LIKE '%Houston, TX%';

-- Q26: Employees whose first name is 4 letters starting with 'J'.
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE FNAME LIKE 'J___';

-- Q26B: Employees whose first name starts with 'J'.
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE FNAME LIKE 'J%';

-- Q27: Show the effect of a 10% raise for employees working on 'ProductX'.
SELECT E.FNAME, E.LNAME, 1.1 * E.SALARY AS NEW_SALARY
FROM EMPLOYEE E, WORKS_ON W, PROJECT P
WHERE E.SSN = W.ESSN
  AND W.PNO = P.PNUMBER
  AND P.PNAME = 'ProductX';

-- Q28: Employees and projects they work on, ordered by department and employee name.
SELECT D.DNAME, E.LNAME, E.FNAME, P.PNAME
FROM DEPARTMENT D, EMPLOYEE E, WORKS_ON W, PROJECT P
WHERE D.DNUMBER = E.DNO
  AND E.SSN = W.ESSN
  AND W.PNO = P.PNUMBER
ORDER BY D.DNAME, E.LNAME;

---------------------------------------------------------------
-- 5. INSERT / UPDATE / DELETE EXAMPLES
---------------------------------------------------------------

-- U1: Insert a full employee tuple.
INSERT INTO EMPLOYEE
VALUES ('Richard','K','Marini','653298653',
        '1952-12-30','98 Oak Forest, Katy, TX',
        'M',37000,'987654321',4);

-- U1A: Insert an employee when only name and SSN are known.
INSERT INTO EMPLOYEE (FNAME, LNAME, SSN)
VALUES ('Richard','Marini','653298653');

-- U4A: Delete all employees with last name 'Brown'.
DELETE FROM EMPLOYEE
WHERE LNAME = 'Brown';

-- U4B: Delete the employee with SSN '123456789'.
DELETE FROM EMPLOYEE
WHERE SSN = '123456789';

-- U4C: Delete employees in the 'Research' department.
DELETE FROM EMPLOYEE
WHERE DNO IN (
  SELECT DNUMBER
  FROM DEPARTMENT
  WHERE DNAME = 'Research'
);

-- U4D: Delete all employees (table becomes empty).
DELETE FROM EMPLOYEE;

-- U5: Change location and controlling department of project 10.
UPDATE PROJECT
SET PLOCATION = 'Bellaire', DNUM = 5
WHERE PNUMBER = 10;

-- U6: Give a 10% raise to employees in 'Research'.
UPDATE EMPLOYEE
SET SALARY = SALARY * 1.1
WHERE DNO IN (
  SELECT DNUMBER
  FROM DEPARTMENT
  WHERE DNAME = 'Research'
);

---------------------------------------------------------------
-- 6. ASSERTION
---------------------------------------------------------------

-- A1: Salary of an employee must not exceed the salary of their department manager.
CREATE ASSERTION SALARY_CONSTRAINT
CHECK (
  NOT EXISTS (
    SELECT *
    FROM EMPLOYEE E, EMPLOYEE M, DEPARTMENT D
    WHERE E.DNO = D.DNUMBER
      AND D.MGRSSN = M.SSN
      AND E.SALARY > M.SALARY
  )
);

---------------------------------------------------------------
-- 7. TRIGGER
---------------------------------------------------------------

-- T1: Before insert/update, if an employee's salary exceeds their supervisor's, inform supervisor.
-- (Assumes a stored procedure INFORM_SUPERVISOR(super_ssn, emp_ssn) exists.)

CREATE TRIGGER INFORM_SUPERVISOR_TRG
BEFORE INSERT OR UPDATE OF SALARY, SUPERSSN ON EMPLOYEE
FOR EACH ROW
WHEN (NEW.SUPERSSN IS NOT NULL AND
      NEW.SALARY > (
        SELECT SALARY
        FROM EMPLOYEE
        WHERE SSN = NEW.SUPERSSN
      ))
CALL INFORM_SUPERVISOR(NEW.SUPERSSN, NEW.SSN);

---------------------------------------------------------------
-- 8. VIEW
---------------------------------------------------------------

-- V1: View combining employee, project, and hours worked.
CREATE VIEW WORKS_ON_NEW AS
SELECT E.FNAME, E.LNAME, P.PNAME, W.HOURS
FROM EMPLOYEE E, PROJECT P, WORKS_ON W
WHERE E.SSN = W.ESSN
  AND W.PNO = P.PNUMBER;

-- Example use: names of employees working on project 'Selena'.
-- (Change 'Selena' to an actual project name in this DB, e.g. 'ProductX'.)
SELECT FNAME, LNAME
FROM WORKS_ON_NEW
WHERE PNAME = 'Selena';

-- Drop the view if no longer needed.
DROP VIEW WORKS_ON_NEW;
