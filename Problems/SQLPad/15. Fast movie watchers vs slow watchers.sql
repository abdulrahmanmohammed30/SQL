WITH cte AS (
    SELECT customer_id, 
           AVG(CEIL(EXTRACT(EPOCH FROM return_ts - rental_ts) / 86400)) AS avg_return_days
    FROM rental 
    WHERE return_ts IS NOT NULL 
    GROUP BY customer_id
)

SELECT 'fast_watcher' AS watcher_category, COUNT(*) AS count 
FROM cte 
WHERE avg_return_days <= 5

UNION ALL

SELECT 'slow_watcher' AS watcher_category, COUNT(*) AS count    
FROM cte 
WHERE avg_return_days > 5;
