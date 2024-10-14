--1. Auditing Changes on a Table
--You have an Employees table that stores information about employees. 
--The company wants to keep an audit trail of any changes made to the Salary field.
--Create a trigger that logs these changes into an AuditLog table, which stores:

--EmployeeID
--OldSalary
--NewSalary
--ChangedAt (date and time of change)

create table SalaryHistory (
 EmployeeID INT,
 OldSalary decimal(10,2),
 NewSalary decimal(10,2),
 ChangedAt datetime2 
)
 
use remove3;
GO

select * from SalaryHistory 

update employees 
set salary = salary + salary * 0.3 
where EmployeeID = 1

alter trigger EmployeesUpdatedSalaryTrigger
on employees 
after update 
as
if update(Salary)
	BEGIN 
	insert into SalaryHistory(EmployeeID, OldSalary, NewSalary, ChangedAt)
	select inserted.EmployeeID, 
		   deleted.Salary as OldSalary, 
		   inserted.Salary as NewSalary, 
		   getdate()
	from inserted
	join deleted 
	on inserted.EmployeeID = deleted.EmployeeID
	END 

--2. Enforcing Business Rules
--In a system with a BankAccounts table, the business rule requires 
--that a customer’s balance can never go below $500. Create a trigger 
--that prevents UPDATE or INSERT operations that would violate this rule.


CREATE TABLE BankAccounts (
    AccountID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Balance DECIMAL(10, 2)
);

INSERT INTO BankAccounts (AccountID, CustomerName, Balance) VALUES
(1, 'Alice Smith', 1000.00),
(2, 'Bob Johnson', 750.00),
(3, 'Charlie Brown', 500.00);

update BankAccounts
set Balance = 300.00 
where AccountID=1

alter trigger CheckBalanceTrigger 
on BankAccounts 
after insert, update 
as
if exists (select 1 from inserted where Balance < 500)
BEGIN
	PRINT 'Balance cannot be less than 500'
	rollback
END



