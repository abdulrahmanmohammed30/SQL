CREATE OR ALTER PROC sp_DeletePost
    @PostID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @error_message NVARCHAR(4000);

        IF @PostID IS NULL
        BEGIN
            SET @error_message = 'PostID cannot be null. Provide a valid ID';
            THROW 50001, @error_message, 16;
        END

        IF NOT EXISTS (SELECT 1 FROM Posts WHERE PostID = @PostID)
        BEGIN
            SET @error_message = 'A post with ID ' + CAST(@PostID AS VARCHAR) + ' does not exist';
            THROW 50002, @error_message, 16;
        END

        DELETE FROM Posts
        WHERE PostID = @PostID;

        COMMIT;
        SELECT @PostID AS DeletedPostID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;

        INSERT INTO dbo.ErrorLogs (
            ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorTime
        ) VALUES (
            ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), GETDATE()
        );

        THROW;
    END CATCH
END;


EXEC sp_DeletePost
@PostID = 600

SELECT * FROM Posts WHERE PostID = 600


EXEC sp_DeletePost
@PostID = 500000