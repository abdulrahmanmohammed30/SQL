with
    player_strike_intervals
    as
    (
        select player_id, start_strike, min(after_end_strike) as after_end_strike
        from
            (
		select m1.player_id,
                m1.match_day as start_strike,
                coalesce(m2.match_day, (SELECT DATEADD(DAY, 1, MAX(match_day)) AS max_match_day FROM matches WHERE player_id = m1.player_id and result='Win')) as after_end_strike
            from matches m1
                left join matches m2
                on  m1.player_id = m2.player_id
                    and m1.result = 'Win'
                    and m2.result !='Win'
                    and m1.match_day < m2.match_day
            WHERE m1.result = 'Win'
	)x
        group by player_id, start_strike
    )

select player_id, max(strike) as longest_streak
from (
	                select psi.player_id, count(m.player_id) as strike
        from player_strike_intervals psi
            join matches m on psi.player_id = m.player_id
                and m.result = 'Win'
                and m.match_day >= psi.start_strike
                and m.match_day < psi.after_end_strike
        group by psi.player_id, psi.start_strike, psi.after_end_strike
    union all
        select distinct player_id, 0 as strike
        from matches 
)x
group by player_id