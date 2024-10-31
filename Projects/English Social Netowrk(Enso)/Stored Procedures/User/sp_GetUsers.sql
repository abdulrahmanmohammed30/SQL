
CREATE OR ALTER PROC sp_GetUsers
AS
BEGIN 
 SET NOCOUNT ON 
	BEGIN TRY 
		SELECT * FROM Users 
	END TRY 
	BEGIN CATCH 
	 INSERT INTO dbo.ErrorLogs
        (
        ErrorNumber,
        ErrorSeverity,
        ErrorState,
        ErrorProcedure,
        ErrorLine,
        ErrorMessage,
        ErrorTime
        )
    VALUES
        (
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE(),
            GETDATE()
        );

        -- Return an error message to the caller
        SELECT 'Unable to Get Users Info. Check ErrorLog for details.' AS ErrorMessage;
        RETURN;
	END CATCH 
END 

SELECT * FROM Users
SELECT * FROM ErrorLogs

EXEC sp_GetUsers;



