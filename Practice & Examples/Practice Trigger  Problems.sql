--2. Creating triggers to prevent updates and deletions
--In the BusDrivers’ database, we can see that the rows in the Depot table are often referenced by many
--child rows in a number of other tables (e.g., Bus, Cleaner and Busdriver). Although there are
--FOREIGN KEY constraints declared on the child tables to maintain the referential integrity, we can
--still define a trigger in the parent table (i.e., Depot) to stop any attempt to change the name of the depot
--and/or to remove any of the depot rows. This is corresponding to the business rule stating that once a
--depot is established, it will be there ‘for ever’ and will not be allowed to change name (although
--unrealistic, we assume that such a rule is necessary).
--Write appropriate PL/SQL statements to create the trigger. Note that the trigger you create is a
--statement level trigger so the ‘for each row ‘statement should not be used. After the trigger is created,
--try to change the name of some depots and delete a row from depot, and see what will happen. 

USE PRACTICE; 
GO;

-- Create Depot table
CREATE TABLE Depot (
    DepotID INT PRIMARY KEY,
    DepotName NVARCHAR(100) NOT NULL
);
GO

-- Create Bus table
CREATE TABLE Bus (
    BusID INT PRIMARY KEY,
    BusModel NVARCHAR(50),
    DepotID INT,
    FOREIGN KEY (DepotID) REFERENCES Depot(DepotID)
);
GO

-- Create Cleaner table
CREATE TABLE Cleaner (
    CleanerID INT PRIMARY KEY,
    CleanerName NVARCHAR(100),
    DepotID INT,
    FOREIGN KEY (DepotID) REFERENCES Depot(DepotID)
);
GO

-- Create BusDriver table
CREATE TABLE BusDriver (
    DriverID INT PRIMARY KEY,
    DriverName NVARCHAR(100),
    DepotID INT,
    FOREIGN KEY (DepotID) REFERENCES Depot(DepotID)
);
GO

-- Insert sample data into Depot
INSERT INTO Depot (DepotID, DepotName) VALUES (1, 'Main Depot');
INSERT INTO Depot (DepotID, DepotName) VALUES (2, 'West Depot');
GO

-- Insert sample data into Bus
INSERT INTO Bus (BusID, BusModel, DepotID) VALUES (101, 'Volvo', 1);
INSERT INTO Bus (BusID, BusModel, DepotID) VALUES (102, 'Mercedes', 2);
GO

-- Insert sample data into Cleaner
INSERT INTO Cleaner (CleanerID, CleanerName, DepotID) VALUES (201, 'John', 1);
INSERT INTO Cleaner (CleanerID, CleanerName, DepotID) VALUES (202, 'Alex', 2);
GO

-- Insert sample data into BusDriver
INSERT INTO BusDriver (DriverID, DriverName, DepotID) VALUES (301, 'Ahmed', 1);
INSERT INTO BusDriver (DriverID, DriverName, DepotID) VALUES (302, 'Sara', 2);
GO

create trigger trigger_Depot 
on Depot 
after update, delete 
as 
rollback;
PRINT 'You are not allowed to delete Depot row'

update depot 
set DepotName = 'Change_Depot'
where DepotID=3


alter table Cleaner 
add Salary INT NOT NULL default 3000  
GO

create trigger trigger_Cleaner 
on Cleaner 
after insert, update 
as 
BEGIN 
	if exists(select 1 from inserted where inserted.Salary >= 5000 or inserted.Salary <= 0)
	BEGIN 
		if exists(select 1 from inserted where inserted.Salary >= 5000) 
			Print 'Salary cannot be greater than 5000'
		else
			Print 'Salary Must be greater than 0'
	  rollback;
	END 
END

update Cleaner
set Salary = 6000 
where CleanerID = 201


--The following relations are given (primary keys are underlined; optional attributes are denoted with
--*):
--• IMP(EMPNO, DEPTNO, ENAME, JOB, SAL)
--• DIP(DEPTNO, DNAME, LOC, MINSAL, MAXSAL)
--Write the trigger which manages the update of the DNAME attribute on the DIP table. When the
--DNAME attribute changes from ’ACCCOUNTING’ to ’SALES’, the wage (SAL attribute) for all
--employees, who work in the corresponding DEPTNO, is increased by 100.

CREATE database remove4;
GO

USE remove4;
GO

CREATE TABLE IMP (
    EMPNO INT PRIMARY KEY,  -- Employee Number as Primary Key
    DEPTNO INT NOT NULL,    -- Department Number (Foreign Key to DIP)
    ENAME VARCHAR(50) NOT NULL, -- Employee Name
    JOB VARCHAR(50) NOT NULL,   -- Job Title
    SAL DECIMAL(10, 2) NOT NULL -- Salary
);
GO

CREATE TABLE DIP (
    DEPTNO INT PRIMARY KEY,    -- Department Number as Primary Key
    DNAME VARCHAR(50) NOT NULL, -- Department Name
    LOC VARCHAR(50),           -- Location (optional)
    MINSAL DECIMAL(10, 2) NOT NULL, -- Minimum Salary
    MAXSAL DECIMAL(10, 2) NOT NULL  -- Maximum Salary
);
GO

INSERT INTO DIP (DEPTNO, DNAME, LOC, MINSAL, MAXSAL) VALUES
(1, 'HR', 'Cairo', 3000.00, 10000.00),
(2, 'IT', 'Alexandria', 5000.00, 15000.00),
(3, 'Finance', 'Giza', 4000.00, 12000.00);
GO

INSERT INTO IMP (EMPNO, DEPTNO, ENAME, JOB, SAL) VALUES
(101, 1, 'Ahmed Ali', 'Manager', 9500.00),
(102, 2, 'Sara Ibrahim', 'Developer', 7000.00),
(103, 3, 'Omar Mostafa', 'Accountant', 5000.00),
(104, 1, 'Nour Hassan', 'HR Specialist', 4500.00),
(105, 2, 'Ali Salem', 'System Analyst', 8500.00),
(106, 3, 'Fatma Ezzat', 'Financial Analyst', 6000.00);--The following relations are given (primary keys are underlined; optional attributes are denoted with
--*):
--• IMP(EMPNO, DEPTNO, ENAME, JOB, SAL)
--• DIP(DEPTNO, DNAME, LOC, MINSAL, MAXSAL)
--Write the trigger which manages the update of the DNAME attribute on the DIP table. When the
--DNAME attribute changes from ’ACCCOUNTING’ to ’SALES’, the wage (SAL attribute) for all
--employees, who work in the corresponding DEPTNO, is increased by 100.ALTER TRIGGER TRIGGER_DIP ON DIP after update as if update(DNAME)    BEGIN   PRINT 'SEE'   update IMP    set SAL = SAL + 100    where exists (    select 1 from 	   inserted join deleted 	   on inserted.DEPTNO = deleted.DEPTNO and 	   inserted.DNAME = 'SALES' and 	   deleted.DNAME = 'ACCCOUNTING' 	   where inserted.DEPTNO = IMP.DEPTNO   )   END select * from DIPinsert into DIP(DEPTNO, DNAME, MINSAL, MAXSAL) values (4, 'Accounting', 5000, 8000);update IMP set DEPTNO = 4select * from IMPselect * from DIPupdate DIP set DNAME = 'ACCCOUNTING'where DEPTNO = 4update DIP set DNAME = 'SALES'where DEPTNO = 4use remove3create table Summary (    JobTitle varchar(50) NOT NULL Primary KEY, 	NumberOfEmployees INT )create trigger trigger_employee  on employees after update, delete, insert as BEGIN   update Summary   SET NumberOfEmployees = (SELECT COUNT(1) FROM employees WHERE JobTitle = summary.JobTitle)
   where exists (select 1 from summary where JobTitle = summary.JobTitle)   insert into Summary(JobTitle, NumberOfEmployees)   select JobTitle, count(1) from employees   where not exists(select 1 from summary where Employees.JobTitle = summary.JobTitle)   group by JobTitle    DELETE FROM Summary
    WHERE NOT EXISTS (SELECT 1 FROM employees WHERE employees.JobTitle = summary.JobTitle);END select * from employees delete from employees where EmployeeID = 5select * from departments-- Insert 8 rows into the Employees table
INSERT INTO [dbo].[Employees] (Name, JobTitle, DepartmentID, HireDate, Salary)
VALUES 
('John Doe', 'Software Engineer', 1, '2022-01-15', 55000.00),
('Jane Smith', 'Software Engineer', 1, '2021-06-10', 60000.00),
('Ahmed Ali', 'Database Administrator', 2, '2020-11-05', 70000.00),
('Sara Jones', 'Project Manager', 3, '2019-07-25', 80000.00),
('Mohamed Youssef', 'Business Analyst', 4, '2023-03-01', 65000.00),
('Emily Davis', 'HR Specialist', 5, '2022-10-19', 50000.00),
('Omar Farouk', 'System Administrator', 2, '2021-09-17', 72000.00),
('Lina El-Sayed', 'Marketing Manager', 5, '2020-04-08', 75000.00);
select * from summary 
select JobTitle, count(EmployeeID) as NumberOfEmployees
from employees 
group by jobtitle
