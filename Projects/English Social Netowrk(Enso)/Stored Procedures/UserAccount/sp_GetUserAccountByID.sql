CREATE OR ALTER PROC sp_GetUserAccountByID
    @UserAccountID INT
AS
BEGIN
    SET NOCOUNT ON
    IF @UserAccountID IS NULL
   BEGIN
    THROW 50001, 'UserAccountID was not provided',16
END

IF NOT EXISTS (SELECT 1
FROM UserAccounts
WHERE UserAccountID = @UserAccountID)
   BEGIN
THROW 50001, 'User with specified ID doesn''t exist',16
END
BEGIN TRY 
      SELECT * FROM UserAccounts 
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

        SELECT 'Unable to GET User Account. Check ErrorLog for details.' AS ErrorMessage;
        RETURN;
   END CATCH
END 
GO 

EXEC sp_GetUserAccountByID @UserAccountID = 58;
EXEC sp_GetUserAccountByID @UserAccountID = 999;
EXEC sp_GetUserAccountByID @UserAccountID = NULL;
-- Rename the table temporarily to simulate an error
EXEC sp_rename 'UserAccounts', 'UserAccountsTemp';
EXEC sp_GetUserAccountByID @UserAccountID = 1;
-- Rename the table back to restore functionality
EXEC sp_rename 'UserAccountsTemp', 'UserAccounts';
