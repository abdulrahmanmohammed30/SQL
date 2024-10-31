
CREATE PROC sp_DeleteUser 
@UserID INT 
AS
BEGIN 
 SET NOCOUNT ON 
	 IF @UserID IS NULL 
        THROW 50005, 'Could not delete User. Provided ID was null.', 16;

    IF NOT EXISTS (
        SELECT 1
    FROM Users
    WHERE UserID = @UserID
    )
        THROW 50006, 'No User with the provided ID exists.', 16;
	BEGIN TRY 
		DELETE FROM Users 
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
        SELECT 'Unable to Delete User. Check ErrorLog for details.' AS ErrorMessage;
        RETURN;
	END CATCH 
END 

SELECT * FROM Users
SELECT * FROM ErrorLogs

EXEC sp_DeleteUser @UserID = 58;
EXEC sp_DeleteUser @UserID = NULL;
EXEC sp_DeleteUser @UserID = 9999; 
