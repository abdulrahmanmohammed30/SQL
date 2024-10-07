
-- I am using different database 

-- 1 
select 
dense_rank() over(order by age) 
from Individuals.Teachers

-- 2 
CREATE TABLE AdventureWorks_Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    weight DECIMAL(10, 2)
);  
Go

-- Insert 30 products with different weights
INSERT INTO AdventureWorks_Products (product_id, product_name, weight) VALUES
(1, 'Product A', 1.5), (2, 'Product B', 2.0), (3, 'Product C', 3.2), 
(4, 'Product D', 4.7), (5, 'Product E', 5.1), (6, 'Product F', 6.3), 
(7, 'Product G', 7.5), (8, 'Product H', 8.1), (9, 'Product I', 9.9),
(10, 'Product J', 10.5), (11, 'Product K', 11.2), (12, 'Product L', 12.3),
(13, 'Product M', 13.7), (14, 'Product N', 14.5), (15, 'Product O', 15.0),
(16, 'Product P', 16.2), (17, 'Product Q', 17.8), (18, 'Product R', 18.5),
(19, 'Product S', 19.0), (20, 'Product T', 20.5), (21, 'Product U', 21.1),
(22, 'Product V', 22.8), (23, 'Product W', 23.5), (24, 'Product X', 24.1),
(25, 'Product Y', 25.7), (26, 'Product Z', 26.2), (27, 'Product AA', 27.8),
(28, 'Product AB', 28.9), (29, 'Product AC', 29.7), (30, 'Product AD', 30.5);
Go

select *, NTILE(30) over (order by weight) from AdventureWorks_Products as weight_segment

--3 
-- Create the table for ITI instructors with salary and department
CREATE TABLE ITI_Instructors (
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    department_name VARCHAR(100),
    salary DECIMAL(10, 2)
);
GO

-- Insert 30 instructors with various salaries in different departments
INSERT INTO ITI_Instructors (instructor_id, first_name, last_name, department_id, department_name, salary) VALUES
(1, 'John', 'Doe', 1, 'CS', 6000), (2, 'Jane', 'Smith', 1, 'CS', 7500), 
(3, 'Michael', 'Brown', 1, 'CS', 7200), (4, 'Emily', 'Davis', 2, 'Math', 5000), 
(5, 'Chris', 'Wilson', 2, 'Math', 6700), (6, 'Sarah', 'Johnson', 2, 'Math', 5800),
(7, 'David', 'Jones', 3, 'Physics', 9000), (8, 'Laura', 'Garcia', 3, 'Physics', 7500),
(9, 'Paul', 'Martinez', 3, 'Physics', 8500), (10, 'Daniel', 'Hernandez', 4, 'Chemistry', 6500),
(29, 'Betty', 'Clark', 5, 'Biology', 4500), (30, 'Helen', 'Jackson', 5, 'Biology', 4800);
GO


select department_name,salary from 
(
  select department_name,salary, dense_rank() over(partition by department_id order by salary desc) as rank
  from ITI_Instructors
) t
where rank < 3
ORDER BY department_name, salary DESC;

-- 4 
-- Create the table for works_for with project duration
CREATE TABLE Company_SD_Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    duration_days INT
);
Go

-- Insert 30 project records with different durations
INSERT INTO Company_SD_Projects (project_id, project_name, duration_days) VALUES
(1, 'Project A', 100), (2, 'Project B', 150), (3, 'Project C', 200),
(4, 'Project D', 250), (5, 'Project E', 300), (6, 'Project F', 350),
(7, 'Project G', 400), (8, 'Project H', 450), (9, 'Project I', 500),
(10, 'Project J', 550), -- (Add remaining records similarly up to 30)
(29, 'Project Y', 620), (30, 'Project Z', 670);
Go

select * from 
(
  select *, 
  dense_rank() over(order by duration_days desc) as rank
  from Company_SD_Projects
)t
where rank = 3 

