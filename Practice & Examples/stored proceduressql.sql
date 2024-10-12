create procedure GetCustomer @id int 
as 
select * 
from customer
where customer.customer_id = @id

GetCustomer 3001



Create procedure AddCustomer @id int, @name varchar(50)
As 
if not exists (select 1 from customer where customer_id = @id) and Len(@name)>0 
Insert into customer (customer_id, cust_name) values (@id, @name)
else 
 select 'User already exists' as ErrorMessage


AddCustomer 600, 'Jack'

Exec AddCustomer 600, 'Jack'

Execute AddCustomer 600, 'Jack'

select *
from customer 


create proc GetCustomersByCity @city varchar(50) 
as 
select * 
from customer 
where city = @city 

GetCustomersByCity 'New York'
Go

use GScraper;
Go 

select * from Examples

create proc GetExamplesContainsByWord @word varchar(255) 
as 
select Text 
from Examples 
where Text LIKE '% ' +@word + ' %'OR
           Text LIKE @word + ' %' OR
		   Text LIKE '% ' + @word OR
		   Text = @word 


GetExamplesContainsByWord see

select * 
from Expressions 

select * 
from Senses 

alter proc GetWordInfo @word varchar(255)  
as 
select e.Text as Word, e.IPA, et.Text as Type, s.Definition , ex.Text as Example
from Expressions e
join Senses s on s.ExpressionId = e.Id
join ExpressionTypes et on s.ExpressionTypeId = et.Id
Join Examples ex on ex.SenseId = s.Id 
where e.Text = Lower(Trim(@word))

GetWordInfo war


select * 
from Subjects 

create proc GetSubjectsByLevel @Level INT
as 
select * 
from Subjects 
where Level = @Level

GetSubjectsByLevel 3


select * 
from Academics.Feedbacks


