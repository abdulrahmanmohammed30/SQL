

select *
from customer

create view CustomersView_1
with SCHEMABINDING
as 
select customer_id, cust_name, city, grade, salesman_id
from dbo.customer 

CREATE VIEW CustomersView
WITH SCHEMABINDING 
AS 
SELECT customer_id, cust_name, city, grade, salesman_id 
FROM dbo.Customer; 


insert into CustomersView(customer_id, cust_name, city, grade, salesman_id)
values(60000,'Jack30', 'New York', 300, 5002)


create view Cities 
with encryption
as 
select city from customer
