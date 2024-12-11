CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
        /* Write your T-SQL query statement below. */

         select top 1 e1.salary
         from  (select distinct salary from employee) e2
         join employee e1 on e2.salary >= e1.salary 
         group by e1.id, e1.salary
         having count(e2.salary) = @N
    );
END


--- 
--Another Solution using offset 
-- CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
-- BEGIN
--     RETURN (
--         /* Write your T-SQL query statement below. */

--         select distinct salary 
--         from employee 
--         order by salary desc 
--         offset iif(@N < 1 OR @N > (SELECT COUNT(DISTINCT salary) FROM employee), (select count(1) from employee), @N-1)  rows 
--         fetch next 1 rows only 
--     );
-- END