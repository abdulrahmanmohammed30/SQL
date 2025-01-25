WITH
    ConsecutiveTransactions
    AS
    (
                    SELECT
                transaction_id,
                customer_id,
                transaction_date,
                1 AS consecutive_days_count
            FROM transactions

        UNION ALL

            SELECT
                t.transaction_id,
                t.customer_id,
                t.transaction_date,
                ct.consecutive_days_count + 1
            FROM ConsecutiveTransactions ct
                JOIN transactions t
                ON ct.transaction_id != t.transaction_id
                    AND ct.customer_id = t.customer_id
                    AND ct.transaction_date = DATEADD(DAY, -1, t.transaction_date)
    ),

    MaxConsecutiveDays
    AS
    (
        SELECT
            MAX(consecutive_days_count) AS max_consecutive_days
        FROM ConsecutiveTransactions
    )

SELECT DISTINCT customer_id
FROM ConsecutiveTransactions
    JOIN MaxConsecutiveDays
    ON ConsecutiveTransactions.consecutive_days_count = MaxConsecutiveDays.max_consecutive_days
ORDER BY customer_id;
