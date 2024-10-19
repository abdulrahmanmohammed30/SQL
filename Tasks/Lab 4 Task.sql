-- Create database
CREATE DATABASE remove7;
GO

USE remove7;
GO

-- Create tables
CREATE TABLE Department (
    DeptNo INT PRIMARY KEY,
    DeptName VARCHAR(50),
    ManagerSSN CHAR(9),
    ManagerStartDate DATE
);

CREATE TABLE Employee (
    SSN CHAR(9) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender CHAR(1),
    Salary DECIMAL(10, 2),
    DeptNo INT,
    SupervisorSSN CHAR(9),
    FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo),
    FOREIGN KEY (SupervisorSSN) REFERENCES Employee(SSN)
);

CREATE TABLE Dependent (
    DependentID INT PRIMARY KEY,
    EmployeeSSN CHAR(9),
    Name VARCHAR(50),
    Gender CHAR(1),
    FOREIGN KEY (EmployeeSSN) REFERENCES Employee(SSN)
);

CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50),
    DeptNo INT,
    FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo)
);

CREATE TABLE WorksOn (
    EmployeeSSN CHAR(9),
    ProjectID INT,
    HoursPerWeek DECIMAL(5, 2),
    PRIMARY KEY (EmployeeSSN, ProjectID),
    FOREIGN KEY (EmployeeSSN) REFERENCES Employee(SSN),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

select Dependent.Name, Dependent.Gender 
from Dependent 
join Employee on EmployeeSSN = Employee.SSN
where Dependent.Gender = 'F' and Employee.Gender ='F'
union 
select Dependent.Name, Dependent.Gender 
from Dependent 
join Employee on EmployeeSSN = Employee.SSN
where Dependent.Gender = 'M' and Employee.Gender ='M'

select WorksOn.ProjectID, Project.ProjectName, sum(HoursPerWeek) 
from WorksOn 
join Project on WorksOn.ProjectID = Project.ProjectID 
group by WorksOn.ProjectID, Project.ProjectName


select top 1* 
from Dependent d
order by EmployeeSSN 

select Employee.DeptNo, Department.DeptName, min(Salary) as MinSalary, 
       max(Salary) as MaxSalary,
	   avg(Salary) as AvgSalary
from Employee 
join Department on Employee.DeptNo = Department.DeptNo
group by Employee.DeptNo, Department.DeptName


select 
 case
 when not exists(select 1 from Dependent where Dependent.EmployeeSSN = Employee.SSN)
 and exists (select 1 from Employee d where Employee.SSN = d.SupervisorSSN)
 then Employee.LastName
 end as LastName
from Employee 



select Employee.DeptNo, Department.DeptName, 
	   avg(Salary) as AvgSalary, count(1) NumberOfEmployees 
from Employee 
join Department on Employee.DeptNo = Department.DeptNo
group by Employee.DeptNo, Department.DeptName
having avg(Salary) < (select avg(salary) from employee)


select concat(FirstName, ' ', LastName) EmployeeName,
       Employee.DeptNo EmployeeDepartment, 
       Project.ProjectID, 
	   Project.ProjectName
from WorksOn
join Employee on WorksOn.EmployeeSSN = EmployeeSSN
join Project on WorksOn.ProjectID = Project.ProjectID
order by Employee.DeptNo, LastName, FirstName

select top 2 Salary 
from Employee 
order by Salary desc 

select concat(FirstName, ' ', LastName) Name 
from Employee 
WHERE EXISTS (
    SELECT 1
    FROM Dependent d
    WHERE d.Name LIKE '%' + Employee.FirstName + '%' OR d.Name LIKE '%' + Employee.LastName + '%'
);


select  * from Project

update Employee 
set Salary = Salary * 1.3 
where exists (
               select 1 from WorksOn 
               join Project on WorksOn.ProjectID = Project.ProjectID 
			   where WorksOn.EmployeeSSN = Employee.SSN and ProjectName = 'Al Rabwah'
			 )

select SSN, concat(FirstName, ' ', LastName) from Employee
where exists (select 1 from Dependent where Dependent.EmployeeSSN = Employee.SSN)


select * from employee 
insert into Department (DeptNo, DeptName, ManagerSSN, ManagerStartDate)
values(100, 'DEPT IT', 999999999, cast('1-11-2006' as date))

update Department 
set ManagerSSN = '666666666'

update Department 
set ManagerSSN = '555555555'
where DeptNo = 20


select * from employee 


update Employee 
set SupervisorSSN = 999999999
where SSN = 555555555
GO


update Department 
set ManagerSSN = 999999999
where ManagerSSN= 555555555
GO

delete from Dependent
where EmployeeSSN = 555555555
GO

update employee 
set SupervisorSSN = null
where SupervisorSSN= 555555555
GO

delete from WorksOn 
where EmployeeSSN = 555555555
GO

delete from employee 
where SSN = 555555555

