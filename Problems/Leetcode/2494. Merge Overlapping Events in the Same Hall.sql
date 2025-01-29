with
    ordered_HallEvents
    as
    (
        select hall_id, start_day, end_day,
            row_number() over(order by hall_id, start_day) as row_num
        from (select distinct *
            from HallEvents) x
    ),
    merge_intervals
    as
    (

                    select hall_id, start_day, end_day, row_num
            from ordered_HallEvents r
            where row_num = 1
        union all
            select r.hall_id, case when r.hall_id = m.hall_id and r.start_day <= m.end_day
		        then m.start_day else r.start_day
			end as start_day,
                case when r.hall_id = m.hall_id and m.end_day <= r.end_day 
		        then r.end_day else r.end_day
		   end as end_day, r.row_num
            from ordered_HallEvents r
                join merge_intervals m on r.row_num = m.row_num + 1
    )
select hall_id, start_day, max(end_day) as end_day
from merge_intervals
group by hall_id, start_day
order by  hall_id, start_day


