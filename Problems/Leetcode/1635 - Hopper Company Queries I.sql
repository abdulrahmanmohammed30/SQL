WITH
    TotalDriversBefore2020
    AS
    (
        SELECT
            1 AS Month,
            COUNT(*) AS TotalDrivers
        FROM Drivers
        WHERE YEAR(join_date) < 2020
    ),
    AllMonths
    AS
    (
                                                                                                    SELECT 1 AS Month
        UNION ALL
            SELECT 2
        UNION ALL
            SELECT 3
        UNION ALL
            SELECT 4
        UNION ALL
            SELECT 5
        UNION ALL
            SELECT 6
        UNION ALL
            SELECT 7
        UNION ALL
            SELECT 8
        UNION ALL
            SELECT 9
        UNION ALL
            SELECT 10
        UNION ALL
            SELECT 11
        UNION ALL
            SELECT 12
    ),
    MonthlyDriverTotals
    AS
    (
                    SELECT
                Month,
                TotalDrivers
            FROM TotalDriversBefore2020
        UNION ALL
            SELECT
                AllMonths.Month,
                COUNT(driver_id) AS TotalDrivers
            FROM AllMonths
                LEFT JOIN Drivers
                ON YEAR(Drivers.join_date) = 2020
                    AND MONTH(Drivers.join_date) = AllMonths.Month
            GROUP BY AllMonths.Month
    ),
    CumulativeDriverTotals
    AS
    (
        SELECT DISTINCT
            Month,
            SUM(TotalDrivers) OVER (ORDER BY Month) AS CumulativeDrivers
        FROM MonthlyDriverTotals
    ),
    MonthlyAcceptedRides
    AS
    (
        SELECT DISTINCT
            MONTH(requested_at) AS Month,
            COUNT(*) OVER (PARTITION BY MONTH(requested_at)) AS AcceptedRides
        FROM AcceptedRides ar
            JOIN Rides r ON ar.ride_id = r.ride_id
        WHERE YEAR(requested_at) = 2020
    )
SELECT
    CumulativeDriverTotals.Month,
    CumulativeDriverTotals.CumulativeDrivers,
    COALESCE(MonthlyAcceptedRides.AcceptedRides, 0) AS AcceptedRides
FROM CumulativeDriverTotals
    LEFT JOIN MonthlyAcceptedRides
    ON CumulativeDriverTotals.Month = MonthlyAcceptedRides.Month;
