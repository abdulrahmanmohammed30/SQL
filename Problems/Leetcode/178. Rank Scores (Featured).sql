
with DistinctScores as (
    select distinct score from scores 
)


-- you basically have to create two copies of the table scores, one is the normal one and the other one with just the distinct scores which will be helpful to rank the scores. for each current score check with the other copy table you created . The number of distinct scores that are more than the current score will be its rank logically. After that just group it by id and score then order it by the scores to get the desired query output.


-- Find out how many distinct scores are greater than or equal to current score and count them 
select s1.score, count(s2.score) as rank 
from scores s1
join DistinctScores s2 on s2.score >= s1.score 
group by s1.id, s1.score
order by s1.score desc  

