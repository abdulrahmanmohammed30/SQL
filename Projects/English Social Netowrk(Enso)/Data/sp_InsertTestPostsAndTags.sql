CREATE OR ALTER PROCEDURE sp_InsertTestPostsAndTags
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Clear existing data
    DELETE FROM PostTags;
    DELETE FROM Posts;
    DELETE FROM Tags;
    
    -- First, insert common tags
    INSERT INTO Tags (TagID, TagName) VALUES
    (1, N'Technology'),
    (2, N'Travel'),
    (3, N'Food'),
    (4, N'Sports'),
    (5, N'Music'),
    (6, N'Art'),
    (7, N'Fashion'),
    (8, N'Books'),
    (9, N'Movies'),
    (10, N'Gaming'),
    (11, N'Photography'),
    (12, N'Fitness'),
    (13, N'Education'),
    (14, N'Business'),
    (15, N'Science');

    DECLARE @StartDate DATETIME2 = DATEADD(MONTH, -6, GETDATE());
    DECLARE @EndDate DATETIME2 = GETDATE();

    -- Create posts (approximately 200 posts across 50 users)
    ;WITH NumberedPosts AS (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS PostID,
            UserID,
            CASE ABS(CHECKSUM(NEWID())) % 2 + 1 
                WHEN 1 THEN 'Profile' 
                ELSE 'Group' 
            END AS PostType,
            ABS(CHECKSUM(NEWID())) % 3 AS PrivacyType -- For varying privacy settings
        FROM Users
        CROSS JOIN (SELECT TOP 4 1 AS n FROM sys.objects) AS Multiplier -- Each user creates ~4 posts
    )
    INSERT INTO Posts (PostID, UserID, Title, Content, CreatedAt, UpdatedAt, 
                      TotalComments, TotalLikes, MediaURL, PrivacySetting, PostTypeID)
    SELECT 
        n.PostID,
        n.UserID,
        CASE ABS(CHECKSUM(NEWID())) % 5
            WHEN 0 THEN N'My thoughts on the latest tech trends'
            WHEN 1 THEN N'Beautiful sunset at Alexandria beach'
            WHEN 2 THEN N'Traditional Egyptian cuisine at its finest'
            WHEN 3 THEN N'Weekend adventures in Cairo'
            WHEN 4 THEN N'Exciting news to share!'
			ELSE N'Beautiful sunset at Alexandria beach'
        END + N' #' + CAST(n.PostID AS NVARCHAR(10)), -- Make each title unique
        CASE ABS(CHECKSUM(NEWID())) % 5
            WHEN 0 THEN N'Just explored the latest advancements in artificial intelligence. The potential applications in healthcare are truly remarkable! What are your thoughts on AI ethics?'
            WHEN 1 THEN N'Spent the evening watching the sun set over the Mediterranean. The colors were absolutely breathtaking. Sometimes we need to pause and appreciate these moments.'
            WHEN 2 THEN N'Finally mastered my grandmother''s koshari recipe! The secret is in the timing of the crispy onions. Who wants the recipe? 😊'
            WHEN 3 THEN N'Walking through the streets of Old Cairo today reminded me why I love this city so much. The history, the architecture, the people - everything tells a story.'
            WHEN 4 THEN N'Big changes coming soon! Can''t wait to share more details with everyone. Stay tuned! 🎉'
			ELSE  N'Walking through the streets of Old Cairo today reminded me why I love this city so much. The history, the architecture, the people - everything tells a story.'
        END,
        DATEADD(SECOND, 
            ABS(CHECKSUM(NEWID())) % DATEDIFF(SECOND, @StartDate, @EndDate), 
            @StartDate),
        DATEADD(SECOND, 
            ABS(CHECKSUM(NEWID())) % DATEDIFF(SECOND, @StartDate, @EndDate), 
            @StartDate),
        ABS(CHECKSUM(NEWID())) % 50,  -- Random number of comments (0-49)
        ABS(CHECKSUM(NEWID())) % 100, -- Random number of likes (0-99)
        CASE WHEN ABS(CHECKSUM(NEWID())) % 3 = 0 -- 33% chance of having media
            THEN 'https://example.com/media/' + CAST(n.PostID AS VARCHAR) + '.jpg'
            ELSE NULL
        END,
        CASE n.PrivacyType
            WHEN 0 THEN 'P' -- Public
            WHEN 1 THEN 'F' -- Friends
            WHEN 2 THEN 'O' -- Only me
        END,
        (SELECT PostTypeID FROM PostTypes WHERE PostTypeText = n.PostType)
    FROM NumberedPosts n;

    -- Create PostTags (2-4 tags per post)
    ;WITH PostTagCombinations AS (
        SELECT 
            p.PostID,
            t.TagID,
            ROW_NUMBER() OVER (PARTITION BY p.PostID ORDER BY NEWID()) as RN
        FROM Posts p
        CROSS JOIN Tags t
    )
    INSERT INTO PostTags (TagID, PostID)
    SELECT TagID, PostID
    FROM PostTagCombinations
    WHERE RN <= ABS(CHECKSUM(NEWID())) % 3 + 2; -- Random 2-4 tags per post

    -- Update Users.NumOfPosts count based on actual posts
    UPDATE Users
    SET NumOfPosts = (
        SELECT COUNT(*)
        FROM Posts p
        WHERE p.UserID = Users.UserID
    );

    -- Update timestamps to ensure UpdatedAt is always >= CreatedAt
    UPDATE Posts
    SET UpdatedAt = CASE 
        WHEN UpdatedAt < CreatedAt 
        THEN DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 60, CreatedAt)
        ELSE UpdatedAt
    END;
END
GO

