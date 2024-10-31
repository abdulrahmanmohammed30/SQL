
CREATE PROC sp_GetUserByID 
@UserID INT 
AS
BEGIN 
 SET NOCOUNT ON 
	 IF @UserID IS NULL 
        THROW 50005, 'Could not get User Info. Provided ID was null.', 16;

    IF NOT EXISTS (
        SELECT 1
    FROM Users
    WHERE UserID = @UserID
    )
        THROW 50006, 'No User with the provided ID exists.', 16;
	BEGIN TRY 
		SELECT * FROM Users 
		WHERE UserID = @UserID 
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
        SELECT 'Unable to Get User Info. Check ErrorLog for details.' AS ErrorMessage;
        RETURN;
	END CATCH 
END 

SELECT * FROM Users
SELECT * FROM ErrorLogs

EXEC sp_GetUserByID @UserID = 55;
EXEC sp_GetUserByID @UserID = NULL;
EXEC sp_GetUserByID @UserID = 9999; 


