select author
from Quotes 
where author = 'Winston Churchill'

create index idx_author 
on Quotes(author)
GO


use Bikes 
GO

select * 
from Bikeshares

create nonclustered index idx_BikeNumber
on Bikeshares(BikeNumber)

select * into #Bikeshares from Bikeshares 

select BikeNumber 
from #Bikeshares

select BikeNumber 
from Bikeshares