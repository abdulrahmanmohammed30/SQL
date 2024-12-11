with
    cte
    as
    (
        select distinct action_date, post_id
        from Actions
        where action = 'report' and extra is not null and extra = 'spam'
    )
select Round(Avg(percentage_per_day),2) as average_daily_percent
from (
select (cast (count(Removals.post_id) as float) / count(1)) * 100 as percentage_per_day
    from cte
        left join Removals on cte.post_id = Removals.post_id
    group by action_date
)x


-- with
--     cte
--     as
--     (
--         select distinct (count(distinct Removals.post_id) * 1.00 /  count(distinct Actions.post_id)) * 100 as percentage_per_day
--         from Actions
--             left join Removals on Actions.post_id = Removals.post_id
--         where action = 'report' and extra = 'spam'
--         group by action_date

--     )
-- select Round(Avg(percentage_per_day),2) as average_daily_percent
-- from cte