CREATE OR ALTER PROC sp_UpdatePost @PostID INT,
	@Title NVARCHAR(500) = NULL,
	@Content NVARCHAR(MAX) = NULL,
	@MediaURL NVARCHAR(255) = NULL 
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRANSACTION 
	BEGIN TRY
	   	DECLARE @error_message NVARCHAR(4000)

		IF @PostID IS NULL
		BEGIN
			SET @error_message = 'PostID cannot be null. Provide a valid ID';

			THROW 50001,
				@error_message,
				16
		END

		IF NOT EXISTS (
				SELECT 1
				FROM Posts
				WHERE PostID = @PostID
				)
		BEGIN
			SET @error_message = 'A Post with ID ' + CAST(@PostID AS VARCHAR) + '  does not exist';

			THROW 50002,
				@error_message,
				16
		END

		IF @MediaURL IS NOT NULL
			AND TRIM(@MediaURL) = ''
			SET @MediaURL = NULL

		UPDATE Posts
		SET Title = 
		    CASE
			   WHEN @Title IS NOT NULL AND TRIM(@Title) <> '' THEN @Title
			   ELSE Title
			END,
			Content =
			 CASE
			   WHEN @Content IS NOT NULL AND TRIM(@Content) <> '' THEN @Content
			   ELSE Content
			END,
			MediaURL = @MediaURL
		WHERE PostID = @PostID

		COMMIT

		SELECT @PostID AS UpdatePostID
	END TRY

	BEGIN CATCH
	   IF @@TRANCOUNT > 0
		   ROLLBACK;

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


EXEC sp_UpdatePost
@PostID = 600,
@Title = 'Updated Valid Post',
@Content = 'This is a updated test post.'

EXEC sp_UpdatePost
@PostID = NULL,
@Title = 'Updated Valid Post',
@Content = 'This is a updated test post.'

EXEC sp_UpdatePost
@PostID = 600,
@Title = 'Updated Valid Post',
@Content = '    '

EXEC sp_UpdatePost
@PostID = 600,
@Title = '   ',
@Content = '    '