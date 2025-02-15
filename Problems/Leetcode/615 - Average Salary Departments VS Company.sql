
with
    cte
    as
    (
        select format(s.pay_date, 'yyyy-MM') as pay_month, e.department_id,
            avg(s.amount) over (partition by s.pay_date,e.department_id) as department_monthly_payment,
            avg(s.amount) over (partition by s.pay_date) as company_monthly_payment
        from
            salary s join
            employee1 e on s.employee_id = e.employee_id
    )

select pay_month, department_id,
    case 
  when department_monthly_payment > company_monthly_payment then 'higher'
  when department_monthly_payment = company_monthly_payment then 'same'
  else 'lower'
end as comparison
from cte
group by pay_month, department_id, department_monthly_payment, company_monthly_payment
order by department_id