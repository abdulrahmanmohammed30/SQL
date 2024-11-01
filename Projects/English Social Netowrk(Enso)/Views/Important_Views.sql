

--Create a view that shows user profiles with their total activity metrics. Include username, full name, total posts, 
--total followers, and total friends. Would you like to try this one first?
CREATE OR ALTER VIEW vw_UserList
WITH
	ENCRYPTION
AS
	SELECT UserID,
		CONCAT(FirstName, ' ', LastName) as [Name],
		'XXXXXXXXXX' + Right(Phone,3) as Phone,
		Bio,
		NumOfPosts,
		TotalFollowers,
		TotalFriends
	FROM Users 
GO
SELECT *
FROM vw_UserList


--Create a view that displays all posts with their engagement statistics. It should show the post title, author's name, creation date, total likes, total comments, 
--and privacy setting. Only include posts from the last 6 months.
CREATE oR ALTER VIEW vw_Last_six_Months_ViewList
WITH
	ENCRYPTION
AS
	SELECT PostID,
		POSTS.UserID,
		CONCAT(FirstName, ' ', LastName) as AuthorName,
		Title,
		Content,
		TotalComments,
		TotalLikes,
		MediaURL,
		PrivacySetting
	FROM POSTS
		LEFT JOIN Users
		ON Posts.UserID = Users.UserID
	WHERE DATEDIFF(MONTH, POSTS.CreatedAt, GETDATE()) <= 6
GO
SELECT *
FROM vw_Last_six_Months_ViewList


--Create a view that shows group statistics. Include group name, admin's full name, member count, total posts in the group, 
--and the most recent post date. Only include active groups (groups with at least one post).
CREATE OR ALTER VIEW vw_GroupList
WITH
	ENCRYPTION
AS
	SELECT x.GroupID, GroupName, AdminID, AdminName, MemberCount, PostsCount, PhotoURL,
		Posts.PostID,
		Posts.UserID,
		Posts.Title,
		Posts.Content,
		Posts.TotalComments,
		Posts.TotalLikes,
		Posts.MediaURL
	FROM
		(
	SELECT
			Groups.GroupID,
			Groups.Name AS GroupName,
			Groups.AdminID,
			CONCAT(Users.FirstName, ' ', Users.LastName) AS AdminName,
			Groups.PrivacySetting,
			Groups.MemberCount,
			Groups.PostsCount,
			Groups.PhotoURL,
			(SELECT TOP 1
				PostID
			FROM Posts
			WHERE GroupID = Groups.GroupID
			ORDER BY CreatedAt DESC) as PostID
		FROM Groups
			JOIN Users ON Groups.AdminID = Users.UserID
		WHERE PostsCount >= 0 
)x
		JOIN Posts ON x.PostID = Posts.PostID 

GO
SELECT
	*
FROM vw_GroupList

SELECT *
FROM Friendships


--UPDATE Users
--SET country = CASE 
--    WHEN RAND(CHECKSUM(NEWID())) < 0.1 THEN 'USA'
--    WHEN RAND(CHECKSUM(NEWID())) < 0.2 THEN 'Canada'
--    WHEN RAND(CHECKSUM(NEWID())) < 0.3 THEN 'UK'
--    WHEN RAND(CHECKSUM(NEWID())) < 0.4 THEN 'Germany'
--    WHEN RAND(CHECKSUM(NEWID())) < 0.5 THEN 'France'
--    WHEN RAND(CHECKSUM(NEWID())) < 0.6 THEN 'Brazil'
--    WHEN RAND(CHECKSUM(NEWID())) < 0.7 THEN 'Egypt'
--    WHEN RAND(CHECKSUM(NEWID())) < 0.8 THEN 'Japan'
--    WHEN RAND(CHECKSUM(NEWID())) < 0.9 THEN 'Australia'
--    ELSE 'Italy'
--END


--Create a view that provides a friendship network analysis. Show users and their friends' counts, breaking down friends by gender, 
--and include the percentage of friends from the same country as the user.
CREATE OR ALTER VIEW UserStats
WITH
	ENCRYPTION
AS
	WITH
		UserFriends
		AS
		(
			SELECT UserID,
				Country,
				FirstName,
				LastName,
				CASE 
			  WHEN U.UserID <> F.UserID1 THEN F.UserID1
			  ELSE F.UserID2
			END AS FriendID
			FROM Users U
				JOIN Friendships F ON U.UserID = F.UserID1 OR U.UserID = F.UserID2
			WHERE F.FriendshipStatus = 'accepted'
		)
	SELECT UF.UserID,
		CONCAT(UF.FirstName, ' ', UF.LastName) AS [UserName],
		UF.Country,
		SUM (IIF(U.Gender = 'F', 1, 0)) as FemaleFriendsCount,
		SUM (IIF(U.Gender = 'M', 1, 0)) as MaleFriendsCount,
		ROUND( 100 * CAST(SUM(IIF(U.Country = UF.Country, 1, 0)) AS FLOAT) / NULLIF(COUNT(1),0) ,2)AS SameCountryFriendsAvg
	FROM UserFriends UF
		JOIN Users U ON U.UserID = UF.FriendID
	GROUP BY UF.UserID, UF.FirstName, UF.LastName, UF.Country


--Create a view that shows a hierarchical representation of post comments. 
--Include the original post title, comment content, commenter's name, level of nesting (parent/child comments), 
--and the time difference between the post and each comment.


CREATE OR ALTER View CommentsWithLevels
WITH
	ENCRYPTION
AS
	WITH
		CommentsHierarchy(CommentID, Level)
		AS
		(
							SELECT CommentID, 1 AS Level
				FROM PostComments
				WHERE ParentID IS NULL
			UNION ALL
				SELECT PostComments.CommentID, Level + 1
				FROM CommentsHierarchy
					JOIN PostComments ON CommentsHierarchy.CommentID = PostComments.ParentID
		)

	SELECT Posts.Title AS PostTitle,
		Posts.Content AS PostContent,
		PostComments.CommentID,
		PostComments.Content AS CommentConent,
		CONCAT(Users.FirstName, ' ', Users.LastName) AS [UserName],
		CommentsHierarchy.Level AS CommentLevel,
		CAST(DATEDIFF(DAY,  Posts.CreatedAT, PostComments.CreatedAt) AS VARCHAR) + ' Days' AS TimeDifferenceInMinutes
	FROM CommentsHierarchy
		JOIN PostComments
		ON CommentsHierarchy.CommentID = PostComments.CommentID
		JOIN Posts ON Posts.PostID = PostComments.PostID
		JOIN Users ON Users.UserID = PostComments.UserID