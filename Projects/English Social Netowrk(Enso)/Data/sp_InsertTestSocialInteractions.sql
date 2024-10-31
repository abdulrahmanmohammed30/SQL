CREATE OR ALTER PROCEDURE sp_InsertTestSocialInteractions
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Clear existing data
    DELETE FROM Notifications;
    DELETE FROM PrivateMessages;
    DELETE FROM Friendships;

    DECLARE @StartDate DATETIME2 = DATEADD(MONTH, -6, GETDATE());
    DECLARE @EndDate DATETIME2 = GETDATE();
    
    DECLARE @RandomDateTime DATETIME2;
    SET @RandomDateTime = DATEADD(SECOND, 
        ABS(CHECKSUM(NEWID())) % DATEDIFF(SECOND, @StartDate, @EndDate), 
        @StartDate);

    ;WITH RandomUserPairs AS (
        SELECT 
            u1.UserID as UserID1,
            u2.UserID as UserID2,
            ABS(CHECKSUM(NEWID())) % 100 as RandomOrder
        FROM Users u1
        CROSS JOIN Users u2
        WHERE u1.UserID < u2.UserID 
    )
    INSERT INTO Friendships (UserID1, UserID2, FriendshipStatus, CreatedAt, UpdatedAt)
    SELECT TOP 100
        UserID1,
        UserID2,
        CASE 
            WHEN ABS(CHECKSUM(NEWID())) % 100 < 70 THEN 'accepted'  -- 70% accepted
            WHEN ABS(CHECKSUM(NEWID())) % 100 < 85 THEN 'requested' -- 15% requested
            WHEN ABS(CHECKSUM(NEWID())) % 100 < 95 THEN 'blocked'   -- 10% blocked
            ELSE 'terminated'                                        -- 5% terminated
        END,
        DATEADD(SECOND, 
            ABS(CHECKSUM(NEWID())) % DATEDIFF(SECOND, @StartDate, @EndDate), 
            @StartDate),
        DATEADD(SECOND, 
            ABS(CHECKSUM(NEWID())) % DATEDIFF(SECOND, @StartDate, @EndDate), 
            @StartDate)
    FROM RandomUserPairs
    ORDER BY RandomOrder;

    ;WITH MessagePairs AS (
        SELECT 
            f.UserID1 as SenderID,
            f.UserID2 as ReceiverID
        FROM Friendships f
        WHERE f.FriendshipStatus = 'accepted'
        UNION ALL
        SELECT 
            f.UserID2 as SenderID,
            f.UserID1 as ReceiverID
        FROM Friendships f
        WHERE f.FriendshipStatus = 'accepted'
    )
    INSERT INTO PrivateMessages (SenderID, ReceiverID, Content, SentDate, IsRead)
    SELECT TOP 200
        SenderID,
        ReceiverID,
        CASE ABS(CHECKSUM(NEWID())) % 5
            WHEN 0 THEN N'Hey! How are you doing?'
            WHEN 1 THEN N'Did you see the latest football match?'
            WHEN 2 THEN N'Let''s meet up this weekend!'
            WHEN 3 THEN N'Happy birthday! Have a great day!'
            WHEN 4 THEN N'Thanks for the help yesterday!'
			ELSE N'Hey! How are you doing?'
        END,
        DATEADD(SECOND, 
            ABS(CHECKSUM(NEWID())) % DATEDIFF(SECOND, @StartDate, @EndDate), 
            @StartDate),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 80 THEN 1 ELSE 0 END -- 80% read
    FROM MessagePairs
    CROSS JOIN (SELECT TOP 10 1 as n FROM sys.objects) AS Multiplier -- Each pair sends multiple messages
    ORDER BY NEWID();

    -- Create Notifications (various types for different events)
    -- First, friendship-related notifications
    INSERT INTO Notifications (UserID, Type, CreatedAt, IsRead)
    SELECT 
        UserID2,
        'FRIEND_REQUEST',
        CreatedAt,
        CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 70 THEN 1 ELSE 0 END
    FROM Friendships
    WHERE FriendshipStatus = 'requested';

    INSERT INTO Notifications (UserID, Type, CreatedAt, IsRead)
    SELECT 
        UserID2,
        'FRIEND_ACCEPT',
        UpdatedAt,
        CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 70 THEN 1 ELSE 0 END
    FROM Friendships
    WHERE FriendshipStatus = 'accepted';

    -- Message notifications
    INSERT INTO Notifications (UserID, Type, CreatedAt, IsRead)
    SELECT 
        ReceiverID,
        'NEW_MESSAGE',
        SentDate,
        IsRead
    FROM PrivateMessages;

    ;WITH UserCTE AS (
        SELECT UserID FROM Users
    )
    INSERT INTO Notifications (UserID, Type, CreatedAt, IsRead)
    SELECT 
        UserID,
        CASE ABS(CHECKSUM(NEWID())) % 3
            WHEN 0 THEN 'SYSTEM_UPDATE'
            WHEN 1 THEN 'SECURITY_ALERT'
            WHEN 2 THEN 'FEATURE_ANNOUNCEMENT'
        END,
        DATEADD(SECOND, 
            ABS(CHECKSUM(NEWID())) % DATEDIFF(SECOND, @StartDate, @EndDate), 
            @StartDate),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 60 THEN 1 ELSE 0 END -- 60% read
    FROM UserCTE
    WHERE ABS(CHECKSUM(NEWID())) % 100 < 30; -- Only 30% of users get system notifications

    UPDATE Users
    SET TotalFriends = (
        SELECT COUNT(*)
        FROM Friendships f
        WHERE (f.UserID1 = Users.UserID OR f.UserID2 = Users.UserID)
        AND f.FriendshipStatus = 'accepted'
    );
END
GO
