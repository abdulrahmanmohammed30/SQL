CREATE OR ALTER PROC sp_CreatePost @PostID INT,
	@UserID INT, -- Nullable
	@PostTypeID INT, -- Nullable
	@GroupID INT, -- Nullable 
	@Title NVARCHAR(500),
	@Content NVARCHAR(MAX),
	@MediaURL NVARCHAR(255), -- Nullable
	@PrivacySetting CHAR(1)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRY
		DECLARE @error_message VARCHAR(4000)

		IF @PostID IS NULL
		BEGIN
			SET @error_message = 'PostID cannot be null. Provide a valid ID'; 
			THROW 50001,
				@error_message,
				16
		END

		IF EXISTS (
				SELECT 1
				FROM Posts
				WHERE PostID = @PostID
				)
		BEGIN
			SET @error_message = 'A Post with ID ' + CAST(@PostID AS VARCHAR) + '  is in use';
			THROW 50002,
				@error_message,
				16
		END

		IF @UserID IS NOT NULL
			AND NOT EXISTS (
				SELECT 1
				FROM Users
				WHERE UserID = @UserID
				)
		BEGIN
			SET @error_message = 'User with ID ' +  CAST(@UserID AS VARCHAR) + ' doesn''exist';
			THROW 50003,
				@error_message,
				16
		END

		IF @PostTypeID IS NOT NULL
			AND NOT EXISTS (
				SELECT 1
				FROM PostTypes
				WHERE PostTypeID = @PostTypeID
				)
		BEGIN
			SET @error_message = 'PostType with ID ' + CAST(@PostTypeID AS VARCHAR) + ' doesn''exist';
			THROW 50004,
				@error_message,
				16
		END

		IF @GroupID IS NOT NULL
			AND NOT EXISTS (
				SELECT 1
				FROM Groups
				WHERE GroupID = @GroupID
				)
		BEGIN
			SET @error_message = 'Group with ID ' + CAST(@GroupID AS VARCHAR) + ' doesn''exist';
			THROW 50005,
				@error_message,
				16
		END

		IF @Title IS NULL
			OR TRIM(@Title) = ''
		BEGIN
			SET @error_message = 'Title is a required field ';
			THROW 50006,
				@error_message,
				16
		END

		IF @Content IS NULL
			OR TRIM(@Content) = ''
		BEGIN
			SET @error_message = 'Content is a required field ';
			THROW 50007,
				@error_message,
				16
		END

		IF @PrivacySetting IS NULL
		BEGIN
			SET @error_message = 'PrivacySetting is a required field ';
			THROW 50008,
				@error_message,
				16
		END

		IF @PrivacySetting NOT IN (
				'P',
				'F',
				'O'
				)
		BEGIN
			SET @error_message = 'Invalid value was provided for PrivacySetting field  ';
			THROW 50009,
				@error_message,
				16
		END

		IF @GroupID IS NOT NULL AND @PrivacySetting <> 'P'
		BEGIN
			SET @error_message = 'Invalid value was provided for PrivacySetting field. Group Posts must be public';
			THROW 50010,
				@error_message,
				16		   
		END

		IF @MediaURL IS NOT NULL
			AND TRIM(@MediaURL) = ''
			SET @MediaURL = NULL

		INSERT INTO Posts (
			PostID,
			UserID,
			PostTypeID,
			GroupID,
			Title,
			Content,
			MediaURL,
			PrivacySetting
			)
		VALUES (
			@PostID,
			@UserID,
			@PostTypeID,
			@GroupID,
			@Title,
			@Content,
			@MediaURL,
			@PrivacySetting
			)

		SELECT @PostID AS CreatedPostID
	END TRY

	BEGIN CATCH
		INSERT INTO dbo.ErrorLogs (
			ErrorNumber,
			ErrorSeverity,
			ErrorState,
			ErrorProcedure,
			ErrorLine,
			ErrorMessage,
			ErrorTime
			)
		VALUES (
			ERROR_NUMBER(),
			ERROR_SEVERITY(),
			ERROR_STATE(),
			ERROR_PROCEDURE(),
			ERROR_LINE(),
			ERROR_MESSAGE(),
			GETDATE()
			);

		THROW
	END CATCH
END

SELECT * FROM Posts 
SELECT * FROM Users 
SELECT * FROM PostTypes 

EXEC sp_CreatePost
@PostID = 600,
@UserID = 53,
@PostTypeID = NULL,
@GroupID = NULL,
@Title = 'Valid Post',
@Content = 'This is a test post.',
@MediaURL = NULL,
@PrivacySetting = 'P'
GO
SELECT * FROM Posts WHERE PostID = 600 
GO
DELETE FROM Posts WHERE PostID = 600 
GO 

EXEC sp_CreatePost
@PostID = 601,
@UserID = 56,
@PostTypeID = 2,
@GroupID = NULL,
@Title = 'Valid Post',
@Content = 'This is a test post.',
@MediaURL = 'http://example.com/image.jpg',
@PrivacySetting = 'F'

EXEC sp_CreatePost
@PostID = NULL,
@UserID = 53,
@PostTypeID = NULL,
@GroupID = NULL,
@Title = 'Valid Post',
@Content = 'This is a test post.',
@MediaURL = NULL,
@PrivacySetting = 'P'

EXEC sp_CreatePost
@PostID = 601,
@UserID = 56,
@PostTypeID = 2,
@GroupID = NULL,
@Title = 'Valid Post',
@Content = 'This is a test post.',
@MediaURL = 'http://example.com/image.jpg',
@PrivacySetting = 'F'

EXEC sp_CreatePost
@PostID = 602,
@UserID = 500000,
@PostTypeID = 2,
@GroupID = NULL,
@Title = 'Valid Post',
@Content = 'This is a test post.',
@MediaURL = 'http://example.com/image.jpg',
@PrivacySetting = 'F'

EXEC sp_CreatePost
@PostID = 606,
@UserID = 56,
@PostTypeID = 2,
@GroupID = NULL,
@Title = '    ',
@Content = '    ',
@MediaURL = 'http://example.com/image.jpg',
@PrivacySetting = 'F'
