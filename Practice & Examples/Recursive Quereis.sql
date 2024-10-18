use SocialPlatform;
GO

-- Create the tables
CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE followers (
    id INT PRIMARY KEY,
    leader_id INT foreign key references users(id),
    follower_id INT foreign key references users(id)
);

-- Insert 30 users with real names
INSERT INTO users (id, username) VALUES
(1, 'Me'),
(2, 'The Rock'),
(3, 'Kevin Hart'),
(4, 'Justin Bieber'),
(5, 'Jennifer Lopez'),
(6, 'Snoop Dogg'),
(7, 'Miley Cyrus'),
(8, 'Justin Timberlake'),
(9, 'Selena Gomez'),
(10, 'Taylor Swift'),
(11, 'Ed Sheeran'),
(12, 'Ariana Grande'),
(13, 'Drake'),
(14, 'Beyoncé'),
(15, 'Rihanna'),
(16, 'Adele'),
(17, 'Leonardo DiCaprio'),
(18, 'Brad Pitt'),
(19, 'Angelina Jolie'),
(20, 'Tom Hanks'),
(21, 'Meryl Streep'),
(22, 'Johnny Depp'),
(23, 'Emma Watson'),
(24, 'Chris Hemsworth'),
(25, 'Scarlett Johansson'),
(26, 'Robert Downey Jr.'),
(27, 'Will Smith'),
(28, 'Charlize Theron'),
(29, 'Natalie Portman'),
(30, 'Hugh Jackman');

-- Insert follower relationships to create a 6-level tree
INSERT INTO followers (id, leader_id, follower_id) VALUES
-- Level 1 to 2
(1, 1, 2),  -- Me -> The Rock
(2, 1, 3),  -- Me -> Kevin Hart

-- Level 2 to 3
(3, 2, 4),  -- The Rock -> Justin Bieber
(4, 3, 5),  -- Kevin Hart -> Jennifer Lopez
(5, 3, 6),  -- Kevin Hart -> Snoop Dogg

-- Level 3 to 4
(6, 4, 7),   -- Justin Bieber -> Miley Cyrus
(7, 5, 8),   -- Jennifer Lopez -> Justin Timberlake
(8, 6, 9),   -- Snoop Dogg -> Selena Gomez
(9, 6, 10),  -- Snoop Dogg -> Taylor Swift

-- Level 4 to 5
(10, 7, 11),  -- Miley Cyrus -> Ed Sheeran
(11, 7, 12),  -- Miley Cyrus -> Ariana Grande
(12, 8, 13),  -- Justin Timberlake -> Drake
(13, 9, 14),  -- Selena Gomez -> Beyoncé
(14, 10, 15), -- Taylor Swift -> Rihanna
(15, 10, 16), -- Taylor Swift -> Adele

-- Level 5 to 6
(16, 11, 17), -- Ed Sheeran -> Leonardo DiCaprio
(17, 11, 18), -- Ed Sheeran -> Brad Pitt
(18, 12, 19), -- Ariana Grande -> Angelina Jolie
(19, 12, 20), -- Ariana Grande -> Tom Hanks
(20, 13, 21), -- Drake -> Meryl Streep
(21, 14, 22), -- Beyoncé -> Johnny Depp
(22, 15, 23), -- Rihanna -> Emma Watson
(23, 15, 24), -- Rihanna -> Chris Hemsworth
(24, 16, 25), -- Adele -> Scarlett Johansson
(25, 16, 26), -- Adele -> Robert Downey Jr.
(26, 16, 27), -- Adele -> Will Smith
(27, 16, 28), -- Adele -> Charlize Theron
(28, 16, 29), -- Adele -> Natalie Portman
(29, 16, 30); -- Adele -> Hugh Jackman

---- Verify the data
--SELECT * FROM users ORDER BY id;
--SELECT * FROM followers ORDER BY id;


-- Recursive CTE
WITH countUp(n) AS 
(
    -- Anchor member
    SELECT 1 AS n
    UNION ALL
    -- Recursive member
    SELECT n + 1 
    FROM countUp 
    WHERE n<50
)
SELECT * FROM countUp;
GO


with suggestions (leader_id, follower_id, depth) as
(
	select leader_id, follower_id, 1 as depth 
	from followers 
	where follower_id = 1
	union all 
	select followers.leader_id, 
	followers.follower_id, depth + 1 
	from followers 
	JOIN suggestions on suggestions.leader_id  = followers.follower_id
	where depth < 3
)

select * from followers 

select users.id, users.username 
from suggestions 
join users on users.id = suggestions.leader_Id
where depth > 1


CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(100),
    ManagerID INT NULL,
    Salary DECIMAL(10, 2)
);

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(100),
    ParentCategoryID INT NULL
);


-- Insert data into Employee table
INSERT INTO Employee (EmployeeID, Name, ManagerID, Salary) VALUES
(1, 'John', NULL, 10000.00),   -- CEO, No Manager
(2, 'Sarah', 1, 8000.00),      -- Direct report to John
(3, 'Mark', 1, 7500.00),       -- Direct report to John
(4, 'Lisa', 2, 6000.00),       -- Direct report to Sarah
(5, 'Paul', 2, 6500.00),       -- Direct report to Sarah
(6, 'David', 3, 6200.00),      -- Direct report to Mark
(7, 'Emma', 3, 6000.00),       -- Direct report to Mark
(8, 'Chris', 4, 5500.00),      -- Direct report to Lisa
(9, 'Natalie', 4, 5700.00),    -- Direct report to Lisa
(10, 'Oliver', 5, 5800.00),    -- Direct report to Paul
(11, 'Sophia', 5, 5900.00),    -- Direct report to Paul
(12, 'Harry', 6, 5300.00),     -- Direct report to David
(13, 'Isla', 6, 5200.00),      -- Direct report to David
(14, 'Jack', 7, 5400.00),      -- Direct report to Emma
(15, 'Amelia', 7, 5300.00),    -- Direct report to Emma
(16, 'Lucas', 10, 5100.00),    -- Direct report to Oliver
(17, 'Mia', 11, 5200.00),      -- Direct report to Sophia
(18, 'Oscar', 9, 5000.00),     -- Direct report to Natalie
(19, 'Emily', 12, 5200.00),    -- Direct report to Harry
(20, 'Henry', 14, 5100.00),    -- Direct report to Jack
(21, 'Lily', 15, 5000.00),     -- Direct report to Amelia
(22, 'Daniel', 8, 5300.00),    -- Direct report to Chris
(23, 'Charlotte', 13, 4900.00),-- Direct report to Isla
(24, 'Noah', 16, 4700.00),     -- Direct report to Lucas
(25, 'Sophie', 18, 4600.00),   -- Direct report to Oscar
(26, 'Ella', 19, 4800.00),     -- Direct report to Emily
(27, 'James', 21, 4900.00),    -- Direct report to Lily
(28, 'Grace', 20, 4700.00),    -- Direct report to Henry
(29, 'William', 24, 4600.00),  -- Direct report to Noah
(30, 'Evie', 22, 4500.00);     -- Direct report to Daniel


-- Insert data into Category table
INSERT INTO Category (CategoryID, CategoryName, ParentCategoryID) VALUES
(1, 'Electronics', NULL),          -- Root Category
(2, 'Computers', 1),               -- Subcategory of Electronics
(3, 'Laptops', 2),                 -- Subcategory of Computers
(4, 'Desktops', 2),                -- Subcategory of Computers
(5, 'Cameras', 1),                 -- Subcategory of Electronics
(6, 'Smartphones', 1),             -- Subcategory of Electronics
(7, 'Gaming Laptops', 3),          -- Subcategory of Laptops
(8, 'Ultrabooks', 3),              -- Subcategory of Laptops
(9, 'Workstations', 4),            -- Subcategory of Desktops
(10, 'DSLR', 5),                   -- Subcategory of Cameras
(11, 'Mirrorless', 5),             -- Subcategory of Cameras
(12, 'Flagship Phones', 6),        -- Subcategory of Smartphones
(13, 'Budget Phones', 6),          -- Subcategory of Smartphones
(14, 'Accessories', 1),            -- Subcategory of Electronics
(15, 'Chargers', 14),              -- Subcategory of Accessories
(16, 'Memory Cards', 14),          -- Subcategory of Accessories
(17, 'Power Banks', 14),           -- Subcategory of Accessories
(18, 'Tablets', 2),                -- Subcategory of Computers
(19, 'Convertible Laptops', 3),    -- Subcategory of Laptops
(20, 'Mini PCs', 4),               -- Subcategory of Desktops
(21, 'Pro Cameras', 5),            -- Subcategory of Cameras
(22, 'Entry-Level Cameras', 5),    -- Subcategory of Cameras
(23, 'Gaming Consoles', 1),        -- Subcategory of Electronics
(24, 'PlayStation', 23),           -- Subcategory of Gaming Consoles
(25, 'Xbox', 23),                  -- Subcategory of Gaming Consoles
(26, 'Nintendo Switch', 23),       -- Subcategory of Gaming Consoles
(27, 'Video Games', 1),            -- Subcategory of Electronics
(28, 'PC Games', 27),              -- Subcategory of Video Games
(29, 'Console Games', 27),         -- Subcategory of Video Games
(30, 'VR Headsets', 1);            -- Subcategory of Electronics


select * from Employee 


with ManagersChain(EmployeeID, ManagerID, Level) 
as 
(
	select EmployeeID, ManagerID, 1 as Level 
	from Employee 
	where EmployeeID = 8
	UNION ALL 
	select Employee.EmployeeID, Employee.ManagerID, Level + 1
	from Employee 
	join ManagersChain on ManagersChain.ManagerID = Employee.EmployeeID 
	where Employee.ManagerID is not null 
)
select ManagersChain.EmployeeID,child.Name as EmployeeName,  ManagersChain.ManagerID, parent.Name as ParentName, ManagersChain.Level
from ManagersChain
join Employee child on ManagersChain.EmployeeID = child.EmployeeID 
join Employee parent on ManagersChain.ManagerID = parent.EmployeeID

select * from employee
--select child.EmployeeID, child.Name, child.ManagerID, parent.Name as MangerName,  1 as Level 
--from Employee child 
--join Employee parent on child.ManagerID = parent.EmployeeID
--where child.EmployeeID = 2 



with subordinateEmployees ( EmployeeId, Salary, ManagerId, TotalSalary, Level)
	as 
	(
		select EmployeeId, Salary, ManagerId, cast(Salary as decimal(19,2)) as TotalSalary, 1 as Level
		from employee 
		where ManagerId is null
		union all 
		select employee.EmployeeId, Employee.Salary, employee.ManagerId, 
		cast (Employee.Salary + subordinateEmployees.TotalSalary as decimal(19,2)) as TotalSalary,  Level + 1 
		from employee
		join subordinateEmployees on subordinateEmployees.EmployeeId = employee.ManagerId
		
	)
--first parent salary is not included add it 
select EmployeeId, TotalSalary
from subordinateEmployees
order by TotalSalary desc


WITH SubordinateSalaries (EmployeeID, Salary, ManagerID, TotalSalary) AS (
    SELECT 
        EmployeeID,
        Salary,
        ManagerID,
        cast (Salary as decimal(19,2)) AS TotalSalary
    FROM Employee
    WHERE ManagerID IS NULL -- Start with top-level managers
    
    UNION ALL
    
    SELECT 
        e.EmployeeID,
        e.Salary,
        e.ManagerID,
        cast(ss.TotalSalary + e.Salary as decimal(19,2)) AS TotalSalary
    FROM Employee e
    JOIN SubordinateSalaries ss ON ss.EmployeeID = e.ManagerID
)
SELECT 
    EmployeeID,
    TotalSalary
FROM SubordinateSalaries
ORDER BY TotalSalary DESC;


--Find the Depth of Employee Hierarchy
--Write a query to return the depth (level) of each employee in the hierarchy, 
--where the top-level manager (with no manager) is at level 1, their direct reports are at level 2, and so on.
--Expected output: EmployeeID, Name, HierarchyLevel.

with EmployeesHierarchies 
as 
(
	select EmployeeID, Name, 1 as HierarchyLevel
	from Employee 
	where ManagerID is null
	UNION ALL
	select e.EmployeeID, e.Name, HierarchyLevel + 1
	from EmployeesHierarchies eh
	join Employee e on eh.EmployeeID = e.ManagerID
)
select EmployeeID, Name, HierarchyLevel
from EmployeesHierarchies
order by HierarchyLevel

select * from employee
select * from Category

declare @name varchar(30)  = 'My,Name,is,Abdulrahman,Muhammad,I,am,20,years,old'


CREATE FUNCTION dbo.ExtractAfterNCommas
(
    @InputString VARCHAR(MAX),
    @N INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @Result VARCHAR(MAX)
    DECLARE @StartPos INT
    DECLARE @EndPos INT
    DECLARE @CommaCount INT = 0
    DECLARE @Length INT = LEN(@InputString)
    
    -- Find the start position (after the Nth comma)
    SET @StartPos = 1
    WHILE @CommaCount < @N AND @StartPos <= @Length
    BEGIN
        IF SUBSTRING(@InputString, @StartPos, 1) = ','
            SET @CommaCount = @CommaCount + 1
        SET @StartPos = @StartPos + 1
    END
    
    -- Find the end position (before the next comma or end of string)
    SET @EndPos = @StartPos
    WHILE @EndPos <= @Length AND SUBSTRING(@InputString, @EndPos, 1) != ','
    BEGIN
        SET @EndPos = @EndPos + 1
    END
    
    -- Extract the substring
    SET @Result = SUBSTRING(@InputString, @StartPos, @EndPos - @StartPos)
    
    RETURN LTRIM(RTRIM(@Result))
END


with CategoriesChain
as 
(
	select CategoryID, cast (CategoryName as varchar(max)) as CategoryName, 1 as Depth 
	from category
	where ParentCategoryID is NULL 
	UNION ALL 
	select category.CategoryID, cast((CategoriesChain.CategoryName +'/' + category.CategoryName) as varchar(max)) as CategoryName, Depth + 1
	from CategoriesChain
	join category on CategoriesChain.CategoryID = category.ParentCategoryID
)
--select * 
--from CategoriesChain
--order by Depth, CategoryName, CategoryID


select CategoryName,
(
    select count(1) - 1
	from CategoriesChain
	where CHARINDEX(category.CategoryName, CategoriesChain.CategoryName) > 0
) as NumberOfSubCategories 
from category

select * from category 

with EmployeesWithLevels 
as
(
   select EmployeeID, Name, 1 as Depth
   from Employee 
   where ManagerID is null 
   UNION ALL 
   select e.EmployeeID, e.Name, Depth + 1
   from EmployeesWithLevels el
   join Employee e on el.EmployeeID = e.ManagerID 
) 
select top 1 * 
from EmployeesWithLevels
order by Depth desc


