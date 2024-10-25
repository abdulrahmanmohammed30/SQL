/* Write your T-SQL query statement below */


with DistinctSalaries as (
    select distinct salary, departmentId from Employee 
)

select Department, Employee, Salary 
from (
    select d.name as Department, e1.name as Employee, e1.salary as Salary, count(e2.salary) as rank 
    from Employee e1
    join DistinctSalaries e2 on e2.salary >= e1.salary and e2.departmentId = e1.DepartmentId 
    join Department d on e1.departmentId = d.id
    group by d.name,e1.name,e1.id, e1.salary 
    having count(e2.salary) = 1
)x


