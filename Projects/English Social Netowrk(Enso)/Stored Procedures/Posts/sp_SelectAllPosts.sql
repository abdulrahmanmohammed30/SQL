CREATE OR ALTER PROC sp_SelectAllPosts
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        
        SELECT PostID, Title, Content, MediaURL
        FROM Posts;
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.ErrorLogs (
            ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorTime
        ) VALUES (
            ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), GETDATE()
        );

        THROW;
    END CATCH
END;
