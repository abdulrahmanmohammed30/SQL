With
    cte1
    as
    (
            Select success_date as start_date,
            success_date as end_date
            From succeeded
            where Year(success_date) = 2019
        Union all
            Select cte1.start_date,
                succeeded.success_date as end_date
            From cte1
                Join succeeded on datediff(day,cte1.end_date, succeeded.success_date) = 1
    ),
    cte2
    as
    (
                    Select fail_date as start_date,
                fail_date as end_date
            From Failed
            where Year(fail_date) = 2019
        Union all
            Select cte2.start_date,
                Failed.fail_date as end_date
            From cte2
                Join Failed on datediff(day,cte2.end_date, Failed.fail_date) = 1
    )


    Select distinct 'succeeded' as period_state,
        min(start_date) over (partition by end_date) as start_date,
        max(end_date) over (partition by start_date) end_date
    From cte1
    Where end_date is not null

UNION

    Select distinct 'failed' as period_state,
        min(start_date) over (partition by end_date) as start_date,
        max(end_date) over (partition by start_date) end_date
    From cte2
    Where end_date is not null
order by start_date 
