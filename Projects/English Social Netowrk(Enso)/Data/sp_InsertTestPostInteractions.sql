
-- Now create the stored procedure for generating test data
CREATE OR ALTER PROCEDURE sp_InsertTestPostInteractions
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Clear existing data
    DELETE FROM PostLikes;
    DELETE FROM PostComments;
    DELETE FROM Posts;
    
    DECLARE @StartDate DATETIME2 = DATEADD(MONTH, -6, GETDATE());
    DECLARE @EndDate DATETIME2 = GETDATE();
    
    -- Sample post content for variety
    DECLARE @PostContents TABLE (Content NVARCHAR(MAX))
    INSERT INTO @PostContents VALUES
    (N'Just had an amazing Egyptian breakfast! 🍳'),
    (N'Beautiful sunset at the pyramids today! 🌅'),
    (N'New project at work - excited to get started! 💻'),
    (N'Friday prayer was peaceful today 🕌'),
    (N'Family gathering for Eid preparations ❤️'),
    (N'Traffic in Cairo never gets old 🚗'),
    (N'Who else is watching the football match tonight? ⚽'),
    (N'Made my grandmother''s koshari recipe today 🍜'),
    (N'Studying for finals at Alexandria Library 📚'),
    (N'Weekend vibes at the Red Sea! 🌊');

    -- Sample comment content
    DECLARE @CommentContents TABLE (Content NVARCHAR(MAX))
    INSERT INTO @CommentContents VALUES
    (N'Mashallah! 😊'),
    (N'This is amazing! 👏'),
    (N'Can''t wait to see more!'),
    (N'Thanks for sharing 🙏'),
    (N'Love this! ❤️'),
    (N'Totally agree with you'),
    (N'Keep it up! 👍'),
    (N'This made my day'),
    (N'Beautiful moment captured'),
    (N'Count me in!');

    -- Create 100 Posts (about 2 posts per user on average)
    INSERT INTO Posts (UserID, Content, CreatedAt, UpdatedAt)
    SELECT TOP 100
        u.UserID,
        (SELECT TOP 1 Content FROM @PostContents ORDER BY NEWID()),
        DATEADD(SECOND, 
            ABS(CHECKSUM(NEWID())) % DATEDIFF(SECOND, @StartDate, @EndDate), 
            @StartDate) as CreatedAt,
        DATEADD(SECOND, 
            ABS(CHECKSUM(NEWID())) % DATEDIFF(SECOND, @StartDate, @EndDate), 
            @StartDate) as UpdatedAt
    FROM Users u
    CROSS JOIN (SELECT TOP 2 n = ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
                FROM sys.objects) AS Multiplier
    ORDER BY NEWID();

    -- Create Comments (including nested comments)
    -- First level comments
    INSERT INTO PostComments (PostID, UserID, Content, CreatedAt, UpdatedAt, ParentID)
    SELECT 
        p.PostID,
        u.UserID,
        (SELECT TOP 1 Content FROM @CommentContents ORDER BY NEWID()),
        DATEADD(MINUTE, 
            ABS(CHECKSUM(NEWID())) % 1440, -- Within 24 hours of post
            p.CreatedAt) as CreatedAt,
        DATEADD(MINUTE, 
            ABS(CHECKSUM(NEWID())) % 1440, 
            p.CreatedAt) as UpdatedAt,
        NULL as ParentID
    FROM Posts p
    CROSS JOIN (
        SELECT TOP 3 UserID -- Up to 3 comments per post
        FROM Users 
        WHERE UserID != Posts.UserID -- Don't comment on own post
        ORDER BY NEWID()
    ) u;

    -- Second level comments (replies to comments)
    INSERT INTO PostComments (PostID, UserID, Content, CreatedAt, UpdatedAt, ParentID)
    SELECT 
        pc.PostID,
        u.UserID,
        N'Reply: ' + (SELECT TOP 1 Content FROM @CommentContents ORDER BY NEWID()),
        DATEADD(MINUTE, 
            ABS(CHECKSUM(NEWID())) % 1440, 
            pc.CreatedAt) as CreatedAt,
        DATEADD(MINUTE, 
            ABS(CHECKSUM(NEWID())) % 1440, 
            pc.CreatedAt) as UpdatedAt,
        pc.CommentID
    FROM PostComments pc
    CROSS JOIN (
        SELECT TOP 2 UserID -- Up to 2 replies per comment
        FROM Users 
        WHERE UserID != PostComments.UserID -- Don't reply to own comment
        ORDER BY NEWID()
    ) u
    WHERE pc.ParentID IS NULL -- Only reply to first-level comments
    AND ABS(CHECKSUM(NEWID())) % 100 < 30; -- Only 30% of comments get replies

    -- Create Likes
    INSERT INTO PostLikes (PostID, UserID, CreatedAt)
    SELECT DISTINCT
        p.PostID,
        u.UserID,
        DATEADD(MINUTE, 
            ABS(CHECKSUM(NEWID())) % 1440, 
            p.CreatedAt) as CreatedAt
    FROM Posts p
    CROSS JOIN Users u
    WHERE u.UserID != p.UserID -- Don't like own post
    AND ABS(CHECKSUM(NEWID())) % 100 < 40 -- 40% chance of liking
    ORDER BY NEWID();

    -- Update post metrics
    UPDATE Posts
    SET LikesCount = (
        SELECT COUNT(*) 
        FROM PostLikes pl 
        WHERE pl.PostID = Posts.PostID
    ),
    CommentsCount = (
        SELECT COUNT(*) 
        FROM PostComments pc 
        WHERE pc.PostID = Posts.PostID
    );

    -- Update user post counts
    UPDATE Users
    SET NumOfPosts = (
        SELECT COUNT(*) 
        FROM Posts p 
        WHERE p.UserID = Users.UserID
    );
END
GO