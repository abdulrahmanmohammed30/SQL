with
    i
    as
    (
        select top 1
            rn as accepted_candidates, budget
        from (
		                                    select row_number() over(order by salary, employee_id) rn,
                    sum(salary) over(order by salary, employee_id) budget
                from Candidates
                where experience = 'Senior'
            union
                select 0, 0
	    )x
        where budget <= 70000
        order by budget desc
    ),
    j
    as
    (
        select top 1
            rn as accepted_candidates, budget
        from (
			                                    select row_number() over(order by salary) rn,
                    sum(salary) over(order by salary, employee_id) budget
                from Candidates
                where experience = 'Junior'
            union
                select 0, 0
		    )x
        where budget <= 70000 - (select budget
        from i)
        order by budget desc
    )

--15 spent + 
    select 'Senior' as experience,
        accepted_candidates
    from i
union all
    select 'Junior' as experience,
        accepted_candidates
    from j

