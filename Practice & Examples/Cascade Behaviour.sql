-- Create the employees table
CREATE TABLE employees (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(60) NOT NULL,
    LastName NVARCHAR(60) NOT NULL,
    FullName AS (FirstName + ' ' + LastName),
    salary DECIMAL(19, 4) NOT NULL,
    TaxRate DECIMAL(3, 2) NOT NULL,
    NetSalary AS (salary - salary * TaxRate) PERSISTED
);

-- Insert 30 rows with English names
INSERT INTO employees (FirstName, LastName, salary, TaxRate)
VALUES 
    ('John', 'Smith', 50000.0000, 0.20),
    ('Mary', 'Johnson', 55000.0000, 0.22),
    ('David', 'Williams', 60000.0000, 0.25),
    ('Sarah', 'Brown', 52000.0000, 0.20),
    ('Michael', 'Jones', 58000.0000, 0.23),
    ('Jennifer', 'Davis', 54000.0000, 0.21),
    ('Robert', 'Miller', 62000.0000, 0.26),
    ('Lisa', 'Wilson', 51000.0000, 0.20),
    ('William', 'Taylor', 59000.0000, 0.24),
    ('Elizabeth', 'Anderson', 53000.0000, 0.21),
    ('Richard', 'Thomas', 57000.0000, 0.23),
    ('Barbara', 'Moore', 56000.0000, 0.22),
    ('Joseph', 'Jackson', 61000.0000, 0.25),
    ('Susan', 'White', 52500.0000, 0.20),
    ('Charles', 'Harris', 58500.0000, 0.23),
    ('Margaret', 'Martin', 54500.0000, 0.21),
    ('Christopher', 'Thompson', 63000.0000, 0.26),
    ('Jessica', 'Garcia', 51500.0000, 0.20),
    ('Daniel', 'Martinez', 59500.0000, 0.24),
    ('Nancy', 'Robinson', 53500.0000, 0.21),
    ('Paul', 'Clark', 57500.0000, 0.23),
    ('Karen', 'Rodriguez', 56500.0000, 0.22),
    ('Mark', 'Lewis', 61500.0000, 0.25),
    ('Betty', 'Lee', 52750.0000, 0.20),
    ('Donald', 'Walker', 58750.0000, 0.23),
    ('Sandra', 'Hall', 54750.0000, 0.21),
    ('George', 'Allen', 63500.0000, 0.26),
    ('Ashley', 'Young', 51750.0000, 0.20),
    ('Kenneth', 'King', 59750.0000, 0.24),
    ('Donna', 'Wright', 53750.0000, 0.21);

select NetSalary from employees 

create table Departments (
	ID INT Identity(1,1) primary key,
	Name varchar(30) not null unique
)

alter table employees 
add DepartmentID INT 

alter table employees 
add constraint fk_employees_department 
foreign key(DepartmentID) references Departments(ID) on delete set null 

Insert into Departments (Name) Values ('IT'), ('Customer Service')

update employees 
set DepartmentId = (case when ID >= 1 and ID < 6 then 1 when ID >= 6 and ID <= 30 then 2 end)

delete from departments 
where ID = 1 or ID = 2 

select * from employees


