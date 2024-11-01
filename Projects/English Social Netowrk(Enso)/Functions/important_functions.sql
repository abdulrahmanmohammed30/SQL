--Create a scalar function that calculates a user's account age (in years) based on 
--their CreatedAt date in the Users table.

CREATE OR ALTER FUNCTION CalculateUserAccountAge (@UserID INT)
RETURNS VARCHAR(50)
AS 
BEGIN
   DECLARE @years INT, @months INT, @days INT, @age INT
   SET @days = CAST(DATEDIFF (DAY, (SELECT CreatedAt FROM Users WHERE UserID = @UserID), GETDATE())AS FLOAT) 
   SET @years = (@days % 365)/365
   SET @months = (@days % 365)/30
   SET @days = (@days % 365)%30

   DECLARE @res VARCHAR(50) = 
       CAST(@years AS VARCHAR) + ' year/s, ' +  
       CAST(@months AS VARCHAR) + ' month/s, ' + 
       CAST(@days AS VARCHAR) + ' day/s'
	RETURN @res
END 

SELECT dbo.CalculateUserAccountAge(58)


--Write a table-valued function that returns all posts made by a specific user in the last X months, 
--where X is a parameter.
CREATE FUNCTION GetUserPostsByInLastXMonths(@Months INT)
RETURNS TABLE
AS 
RETURN(
	SELECT * 
	FROM Posts 
	WHERE DATEDIFF(MONTH, CreatedAt, GETDATE()) <= @Months
)
SELECT * FROM dbo.GetUserPostsByInLastXMonths(0)

--Design a scalar function that calculates the total number of interactions (likes + comments)
--for a given post.
CREATE FUNCTION GetPostInteractions(@PostID INT) 
RETURNS INT
AS
BEGIN 
    DECLARE @TotalNumberOfInteractions INT
    SELECT @TotalNumberOfInteractions=TotalComments + TotalLikes 
	FROM Posts
	WHERE PostID = @PostID
	RETURN @TotalNumberOfInteractions
END

SELECT dbo.GetPostInteractions(55)

--Create a function that generates a friendship recommendation score between two users based on mutual
--interests and friends.

--CREATE OR ALTER VIEW UserStats
--WITH
--	ENCRYPTION
--AS
	
--	SELECT UF.UserID,
--		CONCAT(UF.FirstName, ' ', UF.LastName) AS [UserName],
--		UF.Country,
--		SUM (IIF(U.Gender = 'F', 1, 0)) as FemaleFriendsCount,
--		SUM (IIF(U.Gender = 'M', 1, 0)) as MaleFriendsCount,
--		ROUND( 100 * CAST(SUM(IIF(U.Country = UF.Country, 1, 0)) AS FLOAT) / NULLIF(COUNT(1),0) ,2)AS SameCountryFriendsAvg
--	FROM UserFriends UF
--		JOIN Users U ON U.UserID = UF.FriendID
--	GROUP BY UF.UserID, UF.FirstName, UF.LastName, UF.Country


CREATE OR ALTER FUNCTION GetUserSuggestedFriends (
	@UserID INT,
	@Level INT
	)
RETURNS TABLE
AS
RETURN (
		WITH UserFriends AS (
				SELECT UserID,
					CASE 
						WHEN U.UserID <> F.UserID1
							THEN F.UserID1
						ELSE F.UserID2
						END AS FriendID
				FROM Users U
				JOIN Friendships F ON U.UserID = F.UserID1
					OR U.UserID = F.UserID2
				WHERE F.FriendshipStatus = 'accepted'
				),
			UserFriendSuggestionsList(UserID, FriendID, LEVEL) AS (
				SELECT UserID,
					FriendID,
					1 AS LEVEL
				FROM UserFriends
				WHERE UserID = @UserID
				
				UNION ALL
				
				SELECT UF.UserID,
					UF.FriendID,
					LEVEL + 1
				FROM UserFriendSuggestionsList UFSL
				JOIN UserFriends UF ON UFSL.FriendID = UF.UserID
				WHERE LEVEL <= @Level
				)
		SELECT DISTINCT FriendID AS UserID,
			CONCAT (
				FirstName,
				' ',
				LastName
				) AS Name,
			Bio,
			Country,
			ProfileImage,
			NumOFPosts,
			TotalFollowers,
			TotalFriends,
			CASE
			  WHEN UserInterests.InterestID IN (SELECT InterestID FROM UserInterests WHERE @UserID = UserInterests.UserID)
			  THEN Level + 3
			  ELSE Level 
			END AS FriendshipRecommendationScore
		FROM UserFriendSuggestionsList
		JOIN Users ON UserFriendSuggestionsList.FriendID = Users.UserID AND Users.UserID != @UserID
		JOIN UserInterests ON UserFriendSuggestionsList.FriendID = UserInterests.UserID
		WHERE Level > 1 
		
	)


SELECT * FROM dbo.GetUserSuggestedFriends(55,3) 
--UNION 
--		SELECT DISTINCT Users.UserID, 
--			CONCAT (
--					FirstName,
--					' ',
--					LastName
--					) AS Name,
--				Bio,
--				Country,
--				ProfileImage,
--				NumOFPosts,
--				TotalFollowers,
--				TotalFriends
--		FROM Users 
--		JOIN UserInterests ON Users.UserID = UserInterests.UserID
--		WHERE UserInterests.InterestID IN 
--		  (
--		     SELECT InterestID 
--			 FROM Users 
--			 JOIN UserInterests ON @UserID = UserInterests.UserID
--		  )
--		AND Users.UserID <> @UserID

