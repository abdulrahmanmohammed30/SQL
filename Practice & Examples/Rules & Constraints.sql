use Practice;

create table employees (
  ID INT Identity(1,1), 
  FirstName varchar(50) not null, 
  LastName varchar(50) not null, 
  FullName as (FirstName + LastName), 
  Salary decimal (19, 4) unique, 
  City varchar(30) not null default 'New York', 
  DepartmentID INT Foreign key references Departmens(ID) on delete set null on update cascade, 
  Hire_Date datetime not null Check (Year(Hire_Date) >= 2002 and Year(Hire_Date) <= Year(getdate())), 
  gender Bit not null, 
  overtime Decimal(19, 4) not null, 
  NetSalary as (salary + overtime) persisted, 
  Age TinyINT not null, 
  
  -- The following will not work because the getdate is a function that consistently returns a different value 
  -- not all the driven columns can be persisted 
  -- age can be driven but cannot be persisted because it contains a non-derministic function 
  -- non-determinsitic function means a functions relates to data or time, changes in runtime, we have no control over it 
  -- Age as (Year(getdate())- Year(BirthDate)) persisted, 
  Constraint pk_employees_DepartmentID Primary Key (ID), 
  Constraint unique_employees_city unique(City), 
  Constraint valid_employees_age Check (Age >= 22 and Age <= 60), 
  Constraint valid_employees_city Check (City in ('New York'))
 )

 create table Departmens (
  ID INT Identity (1,1) primary key, 
  Name varchar(50) not null unique 
 ); 
 -- Cannot Insert more than one null per unique column 
 -- Msg 2627, Level 14, State 1, Line 12
-- Violation of UNIQUE KEY constraint 'UQ__employee__04261B890C508CEA'. Cannot insert duplicate key in object 'dbo.employees'. The duplicate key value is (<NULL>).

 insert into employees (FirstName, LastName, Salary) Values
 ('Abdulrahman', 'Muhammad', 6000), 
 ('Omar', 'Yasser', null), 
 ('Yomina', 'Salah', null);

 create rule valid_salary as @x>3000 


sp_bindrule valid_salary, 'employees.salary'

-- to delete a rule, you have to unbind it first from all the columns 
sp_unbindrule 'employees.salary'
drop rule valid_salary 

-- you cannot apply more than one rule to a column 
-- so if you applied a rule to a column that already has an existing rule 
-- it will override without mentioning that 
-- rules applied to schema level, constraints applied to table level thus rules can be shared, constraints not 
-- rules applied to new data, constraints old and new data 
-- column can have at most one rule and 0 to n constraints 

 create default d1 as 5000 
 sp_bindefault d1, 'employees.salary'
 sp_unbindefault 'employees.salary'
 drop default d1 

 create rule valid_name as Len(@x) < 22 
 sp_bindrule valid_name, 'employees.FirstName'
 sp_unbindrule 'employees.FirstName'
 drop rule valid_name 


 -- create a datatype 
 create rule r1 as @x > 1000 
 create default d1 as 5000

 sp_addtype ComplexDT, 'int' 

 sp_bindrule r1, ComplexDT
 sp_bindefault d1, ComplexDT 

 -- main goal of rules is to be tied or related to the datatype 
 -- column have only one datatype so it does make sense 
 -- that a column can have at most one rule 



 create rule valid_string as Len(@x) = 22
create default default_string as 'New York' 

sp_addtype string, 'varchar(30)' 
sp_bindrule valid_string, string 
sp_bindefault default_string, string 

-- constraints gets applied first and then rules 
-- you cannot bind more than one rule to a column 
-- if you binded more than one rule to the same datatype, the new binded rule will override the old one 

-- constraint is a specific object applied to table level, cannot be shared, applied to old and new data 
-- Rules is a specific object applied to schema level, can be shared, applied to new data 
-- rules can be tied to a datatype, but constraints cannot be tied to a datatype
-- constraints applied first then rules 
-- unique is not a rule, unique is a constraint 
-- rules are alternative to constraint 

-- create a database with all the constraints and rules you have studied and 
-- create users and add users data 