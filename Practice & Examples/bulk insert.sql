
create table #emp (
  Id INT, 
  Name varchar(50), 
  Age INT
)
bulk insert #emp 
from 'F:\file.txt'
with (fieldterminator=',')

select * from #emp



--snpashot similar to backup but it's lighter than the backup 
-- snapshot is known as readonly database 

create database GScraperSnap 
on 
(
  name='GScraper', -- points to the database MDF 
  filename = 'f:\GScraperSnap.ss' -- snapshot file on the hard disk
)
as snapshot of GScraper

select * from Expressions

