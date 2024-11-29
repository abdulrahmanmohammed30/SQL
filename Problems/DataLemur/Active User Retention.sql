SELECT 
    7 AS month,
    COUNT(distinct ua1.user_id) AS monthly_active_users
FROM 
    user_actions ua1
JOIN 
    user_actions ua2 
ON 
    ua1.user_id = ua2.user_id 
    AND EXTRACT(MONTH FROM ua1.event_date) = 7 
    AND EXTRACT(YEAR FROM ua1.event_date) = 2022 
    AND EXTRACT(MONTH FROM ua2.event_date) = 6
    AND EXTRACT(YEAR FROM ua2.event_date) = 2022;
