
select p.FirstName, p.LastName,
 Lag(p.FirstName, 2) over(order by t.HourlyRate) as PreName,
 Lead(p.FirstName, 2) over(order by t.HourlyRate) as NextName
from Individuals.Teachers t
Join Individuals.Persons p on t.ID =p.ID	

-- Create 'salesmen' table
CREATE TABLE salesmen (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(10, 2)
);

-- Create 'customer' table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT,
    FOREIGN KEY(salesman_id) REFERENCES salesmen(salesman_id)
);

-- Insert 20 rows into 'salesmen' table
INSERT INTO salesmen (salesman_id, name, city, commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5003, 'Pit Alex', 'London', 0.11),
(5004, 'Mc Lyon', 'Paris', 0.14),
(5005, 'Paul Adam', 'Rome', 0.13),
(5006, 'John Doe', 'Berlin', 0.12),
(5007, 'Jane Smith', 'Madrid', 0.10),
(5008, 'Emily Davis', 'Tokyo', 0.09),
(5009, 'Michael Brown', 'Sydney', 0.08),
(5010, 'Chris Johnson', 'Toronto', 0.07),
(5011, 'Patricia Taylor', 'Dubai', 0.06),
(5012, 'Robert Wilson', 'Moscow', 0.05),
(5013, 'Linda Martinez', 'Beijing', 0.04),
(5014, 'David Anderson', 'Seoul', 0.03),
(5015, 'Barbara Thomas', 'Bangkok', 0.02),
(5016, 'Richard Jackson', 'Singapore', 0.01),
(5017, 'Susan White', 'Hong Kong', 0.15),
(5018, 'Joseph Harris', 'Kuala Lumpur', 0.14),
(5019, 'Karen Clark', 'Jakarta', 0.13),
(5020, 'Charles Lewis', 'Manila', 0.12);

-- Insert 20 rows into 'customer' table
INSERT INTO customer (customer_id, cust_name, city, grade, salesman_id) VALUES
(3001, 'Nick Rimando', 'New York', 100, 5001),
(3002, 'Brad Davis', 'New York', 200, 5001),
(3003, 'Graham Zusi', 'California', 200, 5002),
(3004, 'Julian Green', 'London', 300, 5002),
(3005, 'Fahian Inhnson', 'Paris', 300, 5006),
(3006, 'Alex Morgan', 'Berlin', 100, 5006),
(3007, 'Megan Rapinoe', 'Madrid', 200, 5007),
(3008, 'Tobin Heath', 'Tokyo', 300, 5008),
(3009, 'Carli Lloyd', 'Sydney', 100, 5009),
(3010, 'Hope Solo', 'Toronto', 200, 5010),
(3011, 'Abby Wambach', 'Dubai', 300, 5011),
(3012, 'Christie Rampone', 'Moscow', 100, 5012),
(3013, 'Becky Sauerbrunn', 'Beijing', 200, 5013),
(3015, 'Ali Krieger', 'Bangkok', 100, 5015),
(3016, 'Julie Ertz', 'Singapore', 200, 5016),
(3017, 'Crystal Dunn', 'Hong Kong', 300, 5017),
(3018, 'Lindsey Horan', 'Kuala Lumpur', 100, 5018),
(3019, 'Rose Lavelle', 'Jakarta', 200, 5019),
(3020, 'Sam Mewis', 'Manila', 300, 5020);

select  cust_name, name, s.city from 
salesmen s join customer c on s.city = c.city