with
    cte
    as
    (
                    select t.transaction_id,
                t.customer_id,
                t.transaction_date,
                t.transaction_date as min_date,
                t.amount
            from Transactions t
            where t.transaction_id=1
        union all
            select t.transaction_id,
                t.customer_id,
                t.transaction_date,
                case when t.customer_id = c.customer_id and
                    t.transaction_date = dateadd(day, 1, c.transaction_date) and
                    t.amount > c.amount
		    then c.min_date else t.transaction_date
			end as min_date,
                t.amount
            from Transactions t
                join cte c on t.transaction_id = c.transaction_id + 1
    ),
    intervals
    as
    (
        select customer_id, cte.min_date as consecutive_start,
            max(cte.transaction_date) as consecutive_end
        from cte
        group by customer_id, cte.min_date

    )
select customer_id, consecutive_start, consecutive_end
from intervals
where datediff(day, consecutive_start, consecutive_end) >= 2
order by customer_id, consecutive_start
	