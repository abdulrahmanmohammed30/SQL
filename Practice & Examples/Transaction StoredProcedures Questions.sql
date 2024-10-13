create database remove2 
GO 

use remove2;
GO

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    JobTitle NVARCHAR(50) NOT NULL,
    DepartmentID INT,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL
);
GO 
/*
  Exercise: Write a stored procedure that inserts a new employee
  record into the Employees table. The stored procedure should take
  parameters such as name, job title, and salary.
*/
create function IsNullOrEmpty (@Text varchar(255))
returns BIT
Begin
  declare @IsNotValid BIT 
  if (@Text is null or @Text = '')
      SET @IsNotValid = 1 
  else
      SET @IsNotValid = 0
  return @IsNotValid
End
Go


CREATE proc InsertEmployee @Name NVARCHAR(100), 
                           @JobTitle NVARCHAR(50), 
                           @DepartmentID INT, 
						   @HireDate DATE,
						   @Salary DECIMAL(10, 2)
with encryption
as 
Begin 
SET @HireDate = TRY_CONVERT(Date, @HireDate, 101)

if dbo.IsNullOrEmpty(@Name) = 1 or
   dbo.IsNullOrEmpty(@JobTitle) = 1 or 
   @HireDate is null or
   @HireDate < CAST('2006-05-23' AS Date) OR
   @HireDate > getdate() or 
   @Salary is Null or 
   @Salary < 3000
    return 400
insert into Employees (Name, JobTitle, DepartmentID, HireDate, Salary) 
values (@Name, @JobTitle, @DepartmentID, @HireDate, @Salary)
return 201 
END 
GO 

DECLARE @date Date = CONVERT(Date, '2006-08-23')

EXEC InsertEmployee @Name='Daniel Green',
               @JobTitle='Accountant',
			   @DepartmentID=3, 
			   @HireDate=@date, 
			   @Salary=8000

/*
Exercise: Write a stored procedure that takes an employee's salary and calculates a 10% bonus,
returning the bonus amount as an output parameter.
*/
CREATE proc CalculateBonus @salary Decimal(10,2), @Bonus Decimal(10,2) output 
with Encryption
as 
Begin
   SET @Bonus = 0.1 * @salary
End 

declare @Bonus Decimal(10,2)
Exec CalculateBonus 3000,  @Bonus OUTPUT
select @Bonus

/*
  5. Stored Procedure with Error Handling
Exercise: Write a stored procedure that attempts to delete an employee by ID, 
but includes error handling to catch any issues.
*/
ALTER proc DeleteEmployee @EmployeeID INT 
as 
Begin 
Begin Try
 delete from Employees 
 where EmployeeID = @EmployeeID
  PRINT 5/0
 IF @@ROWCOUNT = 0
    PRINT 'No employee found with the specified EmployeeID.';
 ELSE 
    PRINT 'Employee deleted successfully.';
End Try 

Begin Catch 
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        DECLARE @ErrorProcedure NVARCHAR(128) = ERROR_PROCEDURE();

        PRINT 'Error occurred while deleting the employee.';
        PRINT 'Error Number: ' + CAST(@ErrorNumber AS NVARCHAR(10));
        PRINT 'Error Message: ' + @ErrorMessage;
        PRINT 'Error Severity: ' + CAST(@ErrorSeverity AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(@ErrorState AS NVARCHAR(10));
        PRINT 'Error Line: ' + CAST(@ErrorLine AS NVARCHAR(10));
        PRINT 'Error Procedure: ' + ISNULL(@ErrorProcedure, 'N/A');
End Catch
End 
GO

EXEC DeleteEmployee 300 
GO

Create database remove3 
GO
use remove3;
GO

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    JobTitle NVARCHAR(50) NOT NULL,
    DepartmentID INT,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL
); 
GO

CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL,
    Location NVARCHAR(100)
);
GO

CREATE TABLE Projects (
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    ProjectName NVARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
);
GO

ALTER TABLE Employees
ADD CONSTRAINT FK_Employee_Department
FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);
GO

INSERT INTO Departments (DepartmentName, Location)
VALUES 
('Human Resources', 'New York'),
('Finance', 'Chicago'),
('IT', 'San Francisco'),
('Marketing', 'Los Angeles'),
('Sales', 'Boston');
GO

INSERT INTO Employees (Name, JobTitle, DepartmentID, HireDate, Salary)
VALUES 
('John Doe', 'HR Manager', 1, '2020-01-15', 75000),
('Jane Smith', 'Financial Analyst', 2, '2019-05-20', 65000),
('Mike Johnson', 'Software Developer', 3, '2021-03-10', 80000),
('Emily Brown', 'Marketing Specialist', 4, '2018-11-05', 60000),
('David Lee', 'Sales Representative', 5, '2022-02-28', 55000),
('Sarah Wilson', 'IT Support', 3, '2020-07-12', 58000),
('Tom Harris', 'Accountant', 2, '2019-09-30', 62000),
('Lisa Chen', 'HR Assistant', 1, '2021-06-18', 50000),
('Robert Taylor', 'Sales Manager', 5, '2017-04-22', 85000),
('Amanda White', 'Marketing Coordinator', 4, '2022-01-07', 52000),
('Chris Evans', 'Senior Developer', 3, '2018-08-14', 90000),
('Emma Watson', 'Financial Manager', 2, '2016-12-01', 95000),
('Michael Brown', 'IT Manager', 3, '2019-03-25', 88000),
('Olivia Davis', 'Sales Associate', 5, '2021-11-09', 48000),
('Daniel Wilson', 'HR Specialist', 1, '2020-05-30', 58000),
('Sophia Martinez', 'Marketing Manager', 4, '2017-07-19', 82000),
('William Johnson', 'Software Engineer', 3, '2022-04-11', 75000),
('Ava Thompson', 'Financial Advisor', 2, '2019-10-08', 70000),
('James Rodriguez', 'IT Analyst', 3, '2021-01-22', 65000),
('Mia Garcia', 'Sales Executive', 5, '2018-06-14', 72000),
('Ethan Clark', 'HR Coordinator', 1, '2022-03-01', 52000),
('Isabella Moore', 'Marketing Analyst', 4, '2020-09-17', 58000),
('Alexander Lee', 'Database Administrator', 3, '2019-02-28', 78000),
('Charlotte King', 'Accountant', 2, '2021-08-05', 60000),
('Benjamin Wright', 'Sales Manager', 5, '2017-11-30', 88000),
('Amelia Scott', 'IT Support Specialist', 3, '2020-04-09', 54000),
('Lucas Young', 'Marketing Specialist', 4, '2022-05-20', 56000),
('Harper Hill', 'Financial Analyst', 2, '2019-07-11', 68000),
('Henry Adams', 'Software Developer', 3, '2021-10-03', 72000),
('Evelyn Nelson', 'HR Manager', 1, '2018-01-25', 80000);
GO

INSERT INTO EmployeeProjects (EmployeeID, ProjectName, StartDate, EndDate)
VALUES 
(3, 'Website Redesign', '2022-01-01', '2022-06-30'),
(7, 'Annual Audit', '2022-03-15', '2022-04-30'),
(4, 'Social Media Campaign', '2022-02-01', '2022-05-31'),
(5, 'Sales Training Program', '2022-04-01', '2022-07-31'),
(1, 'Employee Handbook Update', '2022-05-01', '2022-06-30'),
(11, 'Mobile App Development', '2022-03-01', '2022-08-31'),
(9, 'Customer Retention Strategy', '2022-06-01', '2022-09-30'),
(2, 'Budget Planning 2023', '2022-07-01', '2022-10-31'),
(6, 'IT Infrastructure Upgrade', '2022-05-15', '2022-11-30'),
(10, 'Product Launch Campaign', '2022-08-01', '2022-12-31'),
(13, 'Cloud Migration', '2022-06-15', '2022-12-15'),
(15, 'Employee Engagement Survey', '2022-09-01', '2022-10-31'),
(16, 'Brand Refresh', '2022-07-15', '2022-11-30'),
(17, 'AI Integration Project', '2022-08-15', '2023-02-28'),
(18, 'Financial Risk Assessment', '2022-10-01', '2022-12-31'),
(20, 'Sales Territory Expansion', '2022-09-15', '2023-03-31'),
(22, 'Market Research Study', '2022-11-01', '2023-01-31'),
(23, 'Database Optimization', '2022-10-15', '2023-01-15'),
(25, 'Customer Loyalty Program', '2022-12-01', '2023-05-31'),
(26, 'Help Desk System Upgrade', '2023-01-01', '2023-03-31'),
(27, 'Content Marketing Strategy', '2023-02-01', '2023-06-30'),
(28, 'Cost Reduction Initiative', '2023-03-01', '2023-08-31'),
(29, 'API Development Project', '2023-01-15', '2023-07-15'),
(30, 'Diversity and Inclusion Program', '2023-04-01', '2023-09-30'),
(8, 'Recruitment Process Optimization', '2023-05-01', '2023-08-31'),
(12, 'Financial Reporting Automation', '2023-06-01', '2023-11-30'),
(14, 'Cybersecurity Enhancement', '2023-03-15', '2023-09-15'),
(19, 'Data Analytics Implementation', '2023-07-01', '2024-01-31'),
(21, 'Employee Training Platform', '2023-08-01', '2024-02-29'),
(24, 'Supply Chain Optimization', '2023-09-01', '2024-03-31');
GO 
alter TABLE EmployeeProjects
DROP constraint FK__EmployeeP__Emplo__3B75D760;
GO
alter table EmployeeProjects
drop column EmployeeID
GO 

sp_rename 'EmployeeProjects', 'Projects'
GO

create TABLE EmployeeProjects (
    EmployeeID INT NOT NULL,                  
    ProjectID INT NOT NULL,                    
    PRIMARY KEY (EmployeeID, ProjectID),      
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) on update cascade on delete cascade, 
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) on update cascade on delete cascade
);
GO

INSERT INTO EmployeeProjects (EmployeeID, ProjectID)
VALUES 
(1, 2), (1, 5),
(2, 3), (2, 10),
(3, 15), (3, 1),
(4, 4), (4, 2),
(5, 6), (5, 12),
(6, 9), (6, 19),
(7, 30), (7, 25),
(8, 23), (8, 14),
(9, 13), (9, 7),
(10, 20), (10, 18),
(11, 11), (11, 16),
(12, 27), (12, 28),
(13, 21), (13, 22),
(14, 29), (14, 26),
(15, 8), (15, 3),
(16, 17), (16, 5),
(17, 4), (17, 1),
(18, 12), (18, 30),
(19, 15), (19, 14),
(20, 10), (20, 8),
(21, 20), (21, 27),
(22, 6), (22, 29),
(23, 9), (23, 11),
(24, 18), (24, 19),
(25, 13), (25, 22),
(26, 7), (26, 28),
(27, 3), (27, 25),
(28, 2), (28, 12),
(29, 30), (29, 17),
(30, 1), (30, 5);
GO

CREATE proc UpdateEmployeeDepartment @EmployeeID INT, @DepartmentName NVARCHAR(50)='' , @DepartmentLocation NVARCHAR(100)=''
as 
if dbo.IsNullOrEmpty(@DepartmentName)= 1 and  dbo.IsNullOrEmpty(@DepartmentLocation)= 1
  return 400 
BEGIN
BEGIN TRANSACTION
BEGIN TRY 
     DECLARE @DepartmentID INT 
	 select @DepartmentID=DepartmentID 
	 from Employees 
	 Where EmployeeID=@EmployeeID

	   IF dbo.IsNullOrEmpty(@DepartmentName)= 0
	      update Departments 
		  set DepartmentName=@DepartmentName
		  where DepartmentID=@DepartmentID

       IF dbo.IsNullOrEmpty(@DepartmentLocation)= 0
	      update Departments 
		  set Location=@DepartmentLocation
		  where DepartmentID=@DepartmentID

	   COMMIT TRANSACTION
	   PRINT 'Department Date were updated successfully'
	   PRINT @@ROWCOUNT
END TRY

BEGIN CATCH 
   	    ROllback TRANSACTION
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        DECLARE @ErrorProcedure NVARCHAR(128) = ERROR_PROCEDURE();

        PRINT 'Error occurred while deleting the employee.';
        PRINT 'Error Number: ' + CAST(@ErrorNumber AS NVARCHAR(10));
        PRINT 'Error Message: ' + @ErrorMessage;
        PRINT 'Error Severity: ' + CAST(@ErrorSeverity AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(@ErrorState AS NVARCHAR(10));
        PRINT 'Error Line: ' + CAST(@ErrorLine AS NVARCHAR(10));
        PRINT 'Error Procedure: ' + ISNULL(@ErrorProcedure, 'N/A');
END CATCH 
END
GO

select * from Departments 

UpdateEmployeeDepartment @EmployeeID= 500,
                         @DepartmentName=''


Create Type EmployeeIDsTable as TABLE (EmployeeID INT)

create proc CreateNewProjectAndAssignEmployees 
            @ProjectName NVARCHAR(100),
			@StartDate DATE, 
			@EndDate DATE,
			@EmployeeIDs EmployeeIDsTable READONLY
as 
BEGIN
--if dbo.IsNullOrEmpty(@ProjectName)= 1
--  return 400 

 BEGIN TRANSACTION 
  BEGIN TRY 
   insert into Projects (ProjectName , StartDate, EndDate ) VALUES(@ProjectName , @StartDate, @EndDate)
   Declare @NewProjectId INT= scope_IDentity() 

   insert into EmployeeProjects(EmployeeID, ProjectID)
   select distinct EmployeeID, @NewProjectId
   from @EmployeeIDs
   COMMIT TRANSACTION
  	PRINT 'Department Date were updated successfully'
 END TRY 

 BEGIN CATCH
  ROllback TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        DECLARE @ErrorProcedure NVARCHAR(128) = ERROR_PROCEDURE();

        PRINT 'Error occurred while deleting the employee.';
        PRINT 'Error Message: ' + @ErrorMessage;
        PRINT 'Error Severity: ' + CAST(@ErrorSeverity AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(@ErrorState AS NVARCHAR(10));
        PRINT 'Error Line: ' + CAST(@ErrorLine AS NVARCHAR(10));
        PRINT 'Error Procedure: ' + ISNULL(@ErrorProcedure, 'N/A');
 ROLLBACK TRANSACTION
 END CATCH
END 

declare @EmployeesIDs EmployeeIDsTable
insert into @EmployeesIDs (EmployeeID)
select EmployeeID from Employees

Exec CreateNewProjectAndAssignEmployees 
            @ProjectName ='GScraper',
			@StartDate = null,
			@EndDate = null,
			@EmployeeIDs = @EmployeesIDs
select EmployeeID, ProjectID from EmployeeProjects



create proc TransferEmployeesBetweenProjects @OldProjectID INT, @NewProjectID INT 
as 
BEGIN
BEGIN TRANSACTION 
BEGIN TRY
	declare @EmployeeIds EmployeeIdsTable  

	insert into @EmployeeIds(EmployeeID)
	select EmployeeID from EmployeeProjects
	where ProjectID= @OldProjectID

	delete from EmployeeProjects
	where  ProjectID= @OldProjectID

	insert into EmployeeProjects(EmployeeID, ProjectID)
	select EmployeeID, @NewProjectID from @EmployeeIds
	where not exists (select 1 from EmployeeProjects ep where ep.EmployeeID = EmployeeID and ep.ProjectID=@NewProjectID)
    COMMIT TRANSACTION
END TRY 
BEGIN CATCH
        ROllback TRANSACTION
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        DECLARE @ErrorProcedure NVARCHAR(128) = ERROR_PROCEDURE();

        PRINT 'Error occurred while deleting the employee.';
        PRINT 'Error Number: ' + CAST(@ErrorNumber AS NVARCHAR(10));
        PRINT 'Error Message: ' + @ErrorMessage;
        PRINT 'Error Severity: ' + CAST(@ErrorSeverity AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(@ErrorState AS NVARCHAR(10));
        PRINT 'Error Line: ' + CAST(@ErrorLine AS NVARCHAR(10));
        PRINT 'Error Procedure: ' + ISNULL(@ErrorProcedure, 'N/A');
END CATCH
END 
GO


exec TransferEmployeesBetweenProjects @OldProjectID=11, @NewProjectID=17 
select * from EmployeeProjects where ProjectID =17


create proc CalculateDeparmentSalaryTotals 
as 
BEGIN
 select DepartmentID, sum(salary) 
 from Employees
 group by DepartmentID
END 

