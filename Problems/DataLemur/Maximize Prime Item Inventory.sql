with cte as (
  select 
    500000 as total, 
    sum(
      case when item_type = 'prime_eligible' then square_footage else null end
    ) * 1.0 as prime_group_cost, 
    count(
      case when item_type = 'prime_eligible' then 1 else null end
    ) as prime_group_items_count, 
    sum(
      case when item_type = 'not_prime' then square_footage else null end
    ) * 1.0 as nonprime_group_cost, 
    count(
      case when item_type = 'not_prime' then 1 else null end
    ) as nonprime_group_items_count 
  from 
    inventory
)

SELECT title as item_type, value as item_count
FROM (
    SELECT 
        'prime_eligible' AS title,
        ROUND(((total - nonprime_group_cost) * 1.0 / prime_group_cost), 0) * prime_group_items_count AS value
    FROM cte
    UNION ALL  
    SELECT  
        'not_prime' AS title,
        ROUND(((((total - (((total - nonprime_group_cost) / prime_group_items_count) * 1.0 * prime_group_items_count)) + nonprime_group_cost) / nonprime_group_cost) * 1.0) * nonprime_group_items_count, 0) AS value
    FROM cte
) AS x;
