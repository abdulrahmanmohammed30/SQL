with
    cte
    as
    (
        select voter,
            round(1.0 / iif(cast (count(candidate) as float) = 0, 1, cast (count(candidate) as float)), 3) as vote_value
        from voting_results
        where candidate is not null and candidate <> ''
        group by voter

    )

select top 1 with ties
    vr.candidate
from voting_results vr
    join cte on vr.voter = cte.voter
group by candidate
order by cast(sum(cte.vote_value) as float) desc

