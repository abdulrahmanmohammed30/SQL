
CREATE OR ALTER PROC sp_DeleteUserAccount
    @UserAccountID INT
AS
BEGIN
    SET NOCOUNT ON
    IF @UserAccountID IS NULL
   BEGIN
    THROW 50001, 'UserAccountID was not provided',16
END

IF NOT EXISTS (SELECT 1
FROM UserAccountS
WHERE UserAccountID = @UserAccountID)
   BEGIN
THROW 50001, 'User with specified ID doesn''t exist',16
END

BEGIN TRY 
      DELETE FROM UserAccounts 
	  WHERE UserAccountID = @UserAccountID
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
        SELECT 'Unable to delete User Account. Check ErrorLog for details.' AS ErrorMessage;
        RETURN;
   END CATCH
END 
GO

SELECT *
FROM dbo.ErrorLogs
EXEC sp_DeleteUserAccount @UserAccountID = 55;
EXEC sp_DeleteUserAccount @UserAccountID = 999;
EXEC sp_DeleteUserAccount @UserAccountID = NULL;
EXEC sp_DeleteUserAccount @UserAccountID = 'ABC';  -- Invalid type

