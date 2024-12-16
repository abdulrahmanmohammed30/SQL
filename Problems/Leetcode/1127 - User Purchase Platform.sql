

WITH UserPlatformSummary AS (
    SELECT DISTINCT user_id, spend_date, determined_platform 
    FROM (
        SELECT DISTINCT platform, user_id, spend_date,
            IIF(COUNT(platform) OVER (PARTITION BY spend_date, user_id) = 1, platform, 'both') AS determined_platform
        FROM Spending 
    ) AS PlatformDetermination
), AvailablePlatforms AS (
    SELECT DISTINCT spend_date, 'desktop' AS platform_type FROM Spending
    UNION 
    SELECT DISTINCT spend_date, 'mobile' AS platform_type FROM Spending
    UNION 
    SELECT DISTINCT spend_date, 'both' AS platform_type FROM Spending
), CompleteSpendingData AS (
    SELECT 
        ap.spend_date, 
        ap.platform_type AS platform, 
        s.user_id, 
        s.amount 
    FROM AvailablePlatforms AS ap
    LEFT JOIN Spending AS s 
        ON s.spend_date = ap.spend_date 
       AND s.platform = ap.platform_type
)
SELECT 
    csd.spend_date,
    COALESCE(ups.determined_platform, csd.platform) AS platform,
    COALESCE(SUM(csd.amount), 0) AS total_amount,
    COUNT(DISTINCT csd.user_id) AS total_users
FROM CompleteSpendingData AS csd
LEFT JOIN UserPlatformSummary AS ups 
    ON csd.user_id = ups.user_id 
   AND csd.spend_date = ups.spend_date 
GROUP BY csd.spend_date, 
         COALESCE(ups.determined_platform, csd.platform)
ORDER BY csd.spend_date, 
        case COALESCE(ups.determined_platform, csd.platform)
		    WHEN 'desktop' THEN 1
			WHEN 'mobile' THEN 2
			WHEN 'both' THEN 3
	    end; 