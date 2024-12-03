
select distinct department_id, '03-2024' as payment_date,
    case
  when avg(COALESCE(amount,0)) over (partition by department_id) > avg(COALESCE(amount,0)) over () then 'higher'
  when avg(COALESCE(amount,0)) over (partition by department_id) < avg(COALESCE(amount,0)) over () then 'lower'
  else 'same'
end as comparison
from employee e
    left join salary s
    on e.employee_id = s.employee_id and
        extract (month from s.payment_date) = 3 and
        extract (year from s.payment_date) = 2024
order by department_id


-- with
--     filtered_employees
--     as
--     (
--         select e.department_id, s.amount
--         from employee e
--             left join salary s on e.employee_id = s.employee_id and
--                 extract (month from s.payment_date) = 3 and
--                 extract (year from s.payment_date) = 2024
--     )

-- select distinct department_id, '03-2024' as payment_date,
--     case
--   when avg(COALESCE(amount,0)) over (partition by department_id) > avg(COALESCE(amount,0)) over () then 'higher'
--   when avg(COALESCE(amount,0)) over (partition by department_id) < avg(COALESCE(amount,0)) over () then 'lower'
--   else 'same'
-- end as comparison
-- from filtered_employees
-- order by department_id



-- with
--     filtered_salaries
--     as
--     (
--         select e.department_id, s.amount
--         from employee e
--             left join salary s on e.employee_id = s.employee_id and
--                 extract (month from s.payment_date) = 3 and
--                 extract (year from s.payment_date) = 2024
--     ),
--     company_avg
--     as
--     (
--         select avg(COALESCE(amount,0)) as avg
--         from filtered_salaries
--     )


-- select distinct department_id, '03-2024' as payment_date,
--     case
--   when avg(COALESCE(amount,0)) over (partition by department_id) > company_avg.avg  then 'higher'
--   when avg(COALESCE(amount,0)) over (partition by department_id) < company_avg.avg then 'lower'
--   else 'same'
-- end as comparison
-- from filtered_salaries, company_avg
-- order by department_id

