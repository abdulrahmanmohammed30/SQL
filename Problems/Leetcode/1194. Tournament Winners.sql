WITH
    player_scores
    AS
    (
        SELECT
            p.group_id,
            p.player_id,
            SUM(IIF(p.player_id = m.first_player, m.first_score, m.second_score)) as total_points
        FROM Players p
            JOIN Matches m ON p.player_id = m.first_player OR p.player_id = m.second_player
        GROUP BY p.group_id, p.player_id
    )
SELECT group_id, player_id
FROM (
    SELECT
        group_id,
        player_id,
        ROW_NUMBER() OVER (
            PARTITION BY group_id 
            ORDER BY total_points DESC, player_id ASC
        ) as row_number
    FROM player_scores
) ranked_players
WHERE row_number = 1;