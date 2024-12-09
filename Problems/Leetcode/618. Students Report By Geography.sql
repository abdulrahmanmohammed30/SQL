select [America], [Asia], [Europe] 
from (select name, continent, row_number() over (partition by continent order by name) as d from student) as st 
pivot 
(
	max(name)
	for continent in ([America], [Asia], [Europe])
)as pt 
