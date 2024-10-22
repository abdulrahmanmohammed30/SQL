--raiseerror('Number should be greater than 1', 16,1)

--declare @var xml = (SELECT ',' + QUOTENAME(Month)
--FROM ProductSales
--FOR XML PATH(''), Type).value('.', 'nvarchar(max)')

--select string_agg(Month, ',') from ProductSales

--select left(Name,4) + right(Name, 4) from products 

--select substring(Text, CHARINDEX(' ', Text) + 1, Len(Text)) as Sentence from Examples 


-- Table 1: Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(100)
);
GO

INSERT INTO Customers (CustomerID, FullName)
VALUES 
(1, 'John Doe'),
(2, 'Alice Johnson'),
(3, 'Michael P. Smith'),
(4, 'Sarah Connor'),
(5, 'Bob A. Brown');

-- Table 2: Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Email NVARCHAR(100)
);
GO

INSERT INTO Employees (EmployeeID, Email)
VALUES 
(1, 'john.doe@example.com'),
(2, 'alice.johnson@work.com'),
(3, 'michael.smith@gmail.com'),
(4, 'sarah.connor@tech.org'),
(5, 'bob.brown@company.net');

-- Table 3: Books
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title NVARCHAR(200)
);
GO

INSERT INTO Books (BookID, Title)
VALUES 
(1, 'The History of Ancient Rome'),
(2, 'The Secrets of the Universe'),
(3, 'A History of Time and Space'),
(4, 'Understanding Quantum Physics'),
(5, 'The Ancient Secrets of Alchemy');


--Question 1: Extracting First and Last Names
--Scenario: You have a table that stores customers' full names as a single column. 
--You need to extract the first name and last name separately.
declare @name varchar(50) = 'John Doe' 
select 
substring(@name, 1, charindex(' ', @name) - 1) FirstName,
substring(@name, charindex(' ', @name) + 1, Len(@name)) LastName

--Question 2: Masking Sensitive Data
--Scenario: You have a table of employee email addresses, but for security purposes, 
--you need to mask part of the email addresses. Specifically, mask the part before the @ sign with *,
--keeping only the first and last character of the email visible.

declare @email varchar(255) = 'michael.smith@gmail.com'
declare @separatorPos INT =  charindex('@', @email)
select  stuff(@email, 1, @separatorPos - 1, left(@email,1) +
			translate(substring(@email,2, @separatorPos -2),'abcdefghijklmnopqrstuvwxyz.','***************************') + 
			substring(@email, @separatorPos -2, 1)) as [Masked Email]
GO

declare @email varchar(255) = 'michael.smith@gmail.com'
declare @separatorPos INT =  charindex('@', @email)
select   (left(@email,1) +
		  REPLICATE('*', @separatorPos - 3) + 
		  substring(@email, @separatorPos-1, Len(@email))) as [Masked Email]
GO


declare @email varchar(255) = 'michael.smith@gmail.com'
declare @masked_email varchar(255) = substring(@email, 1, 1)
declare @index INT = 2

while @index <= Len(@email) and substring(@email, @index, 1) ! = '@'
BEGIN 
 SET @masked_email = @masked_email + '*'
 Set @index+=1
END 

SET @masked_email = @masked_email  + substring(@email, @index - 1, 1)

while @index <= Len(@email) 
BEGIN 
 SET @masked_email = @masked_email + substring(@email, @index, 1)
 Set @index+=1
END
select @masked_email as [Masked Email]

--Question 3: Finding Substring Matches and Counting Occurrences
--Scenario: You have a table of book titles, and you need to find all 
--books that contain a certain word (case-insensitive) 
--and count how many times that word appears in each title.
declare @word varchar(50) = upper('History')
select BookID, Title , ((len(Title) - len(replace(upper(Title), @word, ''))) / len(@word)) as HistoryCount from Books
where charindex(@word, upper(Title)) > 0

BEGIN TRY 
select 3 / 0
END TRY 
BEGIN CATCH 
SELECT ERROR_NUMBER()
SELECT ERROR_MESSAGE()
SELECT ERROR_SEVERITY()
SELECT ERROR_STATE()
SELECT ERROR_LINE()
END CATCH 