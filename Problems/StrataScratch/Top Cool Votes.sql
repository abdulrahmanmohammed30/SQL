select business_name, review_text
from
    (
    select top 1 with ties
        business_name, review_id, review_text, sum(cool) as total
    from yelp_reviews
    group by business_name, review_id, review_text
    order by sum(cool) desc 
)x
