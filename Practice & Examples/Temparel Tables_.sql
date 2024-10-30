
CREATE TABLE Employee 
(	
	empid INT NOT NULL,
	CONSTRAINT Employees_PK PRIMARY KEY(empid),
	empname VARCHAR(25) NOT NULL, 
	deparment VARCHAR(50) NOT NULL, 
	validfrom DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL, 
	validTo DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL, 
	PERIOD FOR SYSTEM_TIME (validfrom,validTo)
)
ALTER TABLE Employee ADD 
  Salary DECIMAL(10,2) NOT NULL
  CONSTRAINT CK_MIN_SALARY DEFAULT (3000)
WITH 
(SYSTEM_VERSIONING = ON
     (HISTORY_TABLE = dbo.Employeeshistory, HISTORY_RETENTION_PERIOD = 5 YEARS)
)



-- Insert 20 initial employees
INSERT INTO Employee (empid, empname, deparment) VALUES 
(1, 'John Smith', 'IT'),
(2, 'Mary Johnson', 'HR'),
(3, 'Robert Brown', 'Finance'),
(4, 'Patricia Davis', 'Marketing'),
(5, 'Michael Wilson', 'IT'),
(6, 'Linda Anderson', 'HR'),
(7, 'James Taylor', 'Finance'),
(8, 'Elizabeth Thomas', 'Marketing'),
(9, 'William Martinez', 'IT'),
(10, 'Barbara Robinson', 'HR'),
(11, 'David Clark', 'Finance'),
(12, 'Jennifer Rodriguez', 'Marketing'),
(13, 'Richard Lewis', 'IT'),
(14, 'Susan Lee', 'HR'),
(15, 'Joseph Walker', 'Finance'),
(16, 'Margaret Hall', 'Marketing'),
(17, 'Charles Young', 'IT'),
(18, 'Sandra King', 'HR'),
(19, 'Thomas Wright', 'Finance'),
(20, 'Lisa Scott', 'Marketing');

-- Wait for 1 second to demonstrate time differences
WAITFOR DELAY '00:00:01';

-- Update some employee departments
UPDATE Employee 
SET deparment = 'Sales' 
WHERE empid IN (4, 8, 12, 16);

WAITFOR DELAY '00:00:01';

-- Update some employee names (married names)
UPDATE Employee
SET empname = 'Mary Williams'
WHERE empid = 2;

UPDATE Employee
SET empname = 'Elizabeth Cooper'
WHERE empid = 8;

WAITFOR DELAY '00:00:01';

-- Transfer some IT employees to Development department
UPDATE Employee
SET deparment = 'Development'
WHERE deparment = 'IT';

-- Query to see current data
SELECT * FROM Employee
ORDER BY empid;

-- Query to see historical data
SELECT *
FROM Employee FOR SYSTEM_TIME ALL
ORDER BY empid, validfrom;

-- Query to see specific changes for one employee
SELECT empid, empname, deparment, validfrom, validTo
FROM Employee FOR SYSTEM_TIME ALL
WHERE empid = 8
ORDER BY validfrom;

-- Query to see data as of 1 minute ago
DECLARE @OneMinuteAgo DATETIME2 = DATEADD(MINUTE, -1, SYSDATETIME());
SELECT *
FROM Employee FOR SYSTEM_TIME AS OF @OneMinuteAgo
ORDER BY empid;


ALTER TABLE Employees ADD 
     validFrom DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL 
	   CONSTRAINT DFT_Employees_validfrom DEFAULT('19000101'),
     validTo DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL 
	   CONSTRAINT DFT_Employees_validto DEFAULT('99991231 23:59:59'),
	 PERIOD FOR SYSTEM_TIME(validFrom, validTo) 

ALTER TABLE EMPLOYEES 
SET 
 (
    SYSTEM_VERSIONING=ON
	(HISTORY_TABLE=dbo.EmployeesHistory_, HISTORY_RETENTION_PERIOD = 5 YEARS)
 )

CREATE TABLE Employee 
(	
	empid INT NOT NULL,
	CONSTRAINT Employees_PK PRIMARY KEY(empid),
	empname VARCHAR(25) NOT NULL, 
	deparment VARCHAR(50) NOT NULL, 
	validfrom DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL, 
	validTo DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL, 
	PERIOD FOR SYSTEM_TIME (validfrom,validTo)
)
WITH 
(SYSTEM_VERSIONING = ON
     (HISTORY_TABLE = dbo.Employeeshistory, HISTORY_RETENTION_PERIOD = 5 YEARS)
)

SELECT * 
FROM Employee

SELECT * FROM dbo.Employeeshistory

SELECT * FROM Employee 

UPDATE Employee 
SET deparment = 'HR' 
WHERE empid = 1

SELECT * FROM Employeeshistory

INSERT INTO dbo.Employee (empid, empname, deparment, Salary)
VALUES(58, 'Sara', 'IT' , 50000.00),
(22, 'Don' , 'HR' , 45000.00),
(33, 'Judy', 'Sales' , 55000.00),
(44, 'Yael', 'Marketing', 55000.00),
(55, 'Sven', 'IT' , 45000.00),
(66, 'Paul', 'Sales' , 40000.00);

SELECT * FROM Employeeshistory


DELETE FROM dbo.Employee
WHERE empid = 52



