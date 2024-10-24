/* Write your T-SQL query statement below */

 select name as results from (
    select top 1 users.name
    from MovieRating 
    join users on users.user_id = MovieRating.user_id
    group by users.name
    order by count(1) desc, users.name asc
 )x
union all

select title from (
    select top 1 movies.title
    from MovieRating 
    join movies on movies.movie_id = MovieRating.movie_id
    where format(MovieRating.created_at, 'yyyy-MMMM') = '2020-February'
    group by movies.title  
    ORDER BY avg(cast(MovieRating.rating as decimal(4,2))) DESC, title ASC     
)x
